import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/couple_model.dart';
import '../../auth/controllers/user_repository.dart';

/// Provider for the couple repository.
final coupleRepositoryProvider = Provider<CoupleRepository>((ref) {
  return CoupleRepository(
    ref.watch(firestoreServiceProvider),
    ref.watch(authServiceProvider),
    ref.watch(userRepositoryProvider),
  );
});

/// Stream the current couple.
final currentCoupleProvider = StreamProvider<CoupleModel?>((ref) {
  final userProfile = ref.watch(currentUserProfileProvider).valueOrNull;
  if (userProfile == null || userProfile.coupleId == null) {
    return Stream.value(null);
  }
  return ref
      .watch(coupleRepositoryProvider)
      .streamCouple(userProfile.coupleId!);
});

class CoupleRepository {
  final FirestoreService _db;
  final AuthService _auth;
  final UserRepository _userRepo;

  CoupleRepository(this._db, this._auth, this._userRepo);

  /// Generate a unique invite code (6-char alphanumeric).
  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final uuid = const Uuid().v4().replaceAll('-', '');
    return List.generate(
      AppConstants.inviteCodeLength,
      (i) => chars[uuid.codeUnitAt(i) % chars.length],
    ).join();
  }

  /// Create an invite code for the current user.
  Future<String> createInviteCode() async {
    final uid = _auth.uid!;
    final code = _generateInviteCode();

    await _db.set(
      collection: AppConstants.inviteCodesCollection,
      docId: code,
      data: {
        'creatorId': uid,
        'code': code,
        'usedBy': null,
        'isUsed': false,
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(
            const Duration(hours: AppConstants.inviteCodeExpiryHours),
          ),
        ),
      },
      merge: false,
    );

    return code;
  }

  /// Accept an invite code and pair the two users.
  Future<CoupleModel> acceptInviteCode({
    required String code,
    required DateTime relationshipStartDate,
  }) async {
    final uid = _auth.uid!;

    // Get the invite code document
    final inviteDoc = await _db.get(
      collection: AppConstants.inviteCodesCollection,
      docId: code.toUpperCase(),
    );

    if (!inviteDoc.exists) {
      throw Exception('Invalid invite code');
    }

    final inviteData = inviteDoc.data() as Map<String, dynamic>;

    if (inviteData['isUsed'] == true) {
      throw Exception('This code has already been used');
    }

    final expiresAt = (inviteData['expiresAt'] as Timestamp).toDate();
    if (DateTime.now().isAfter(expiresAt)) {
      throw Exception('This code has expired');
    }

    final creatorId = inviteData['creatorId'] as String;
    if (creatorId == uid) {
      throw Exception('You cannot use your own invite code');
    }

    // Create the couple document
    final couple = CoupleModel(
      id: '',
      user1Id: creatorId,
      user2Id: uid,
      relationshipStartDate: relationshipStartDate,
      pairedAt: DateTime.now(),
    );

    final coupleRef = await _db.create(
      collection: AppConstants.couplesCollection,
      data: couple.toFirestore(),
    );

    // Update both users with the couple ID
    await Future.wait([
      _userRepo.pairUser(
        uid: creatorId,
        coupleId: coupleRef.id,
        partnerId: uid,
      ),
      _userRepo.pairUser(
        uid: uid,
        coupleId: coupleRef.id,
        partnerId: creatorId,
      ),
    ]);

    // Mark the invite code as used
    await _db.update(
      collection: AppConstants.inviteCodesCollection,
      docId: code.toUpperCase(),
      data: {
        'isUsed': true,
        'usedBy': uid,
      },
    );

    return couple.copyWith(id: coupleRef.id);
  }

  /// Stream a couple by ID.
  Stream<CoupleModel?> streamCouple(String coupleId) {
    return _db
        .streamDoc(
          collection: AppConstants.couplesCollection,
          docId: coupleId,
        )
        .map((doc) {
          if (!doc.exists) return null;
          return CoupleModel.fromFirestore(doc);
        });
  }

  /// Update streak count.
  Future<void> updateStreak(String coupleId, int count) async {
    await _db.update(
      collection: AppConstants.couplesCollection,
      docId: coupleId,
      data: {
        'streakCount': count,
        'lastStreakDate': FieldValue.serverTimestamp(),
      },
    );
  }

  /// Increment streak by 1.
  Future<void> incrementStreak(String coupleId) async {
    await _db.update(
      collection: AppConstants.couplesCollection,
      docId: coupleId,
      data: {
        'streakCount': FieldValue.increment(1),
        'lastStreakDate': FieldValue.serverTimestamp(),
      },
    );
  }
}
