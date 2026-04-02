import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/user_model.dart';

/// Provider for the user repository.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    ref.watch(firestoreServiceProvider),
  );
});

/// Stream the current user's profile.
final currentUserProfileProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(authServiceProvider);
  final uid = auth.uid;
  if (uid == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).streamUser(uid);
});

/// Repository for user-related Firestore operations.
class UserRepository {
  final FirestoreService _db;

  UserRepository(this._db);

  /// Create a new user profile in Firestore.
  Future<void> createUser(UserModel user) async {
    await _db.set(
      collection: AppConstants.usersCollection,
      docId: user.id,
      data: user.toFirestore(),
      merge: false,
    );
  }

  /// Get a user by ID.
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.get(
      collection: AppConstants.usersCollection,
      docId: uid,
    );
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Stream a user by ID.
  Stream<UserModel?> streamUser(String uid) {
    return _db
        .streamDoc(
          collection: AppConstants.usersCollection,
          docId: uid,
        )
        .map((doc) {
          if (!doc.exists) return null;
          return UserModel.fromFirestore(doc);
        });
  }

  /// Update user profile fields.
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.update(
      collection: AppConstants.usersCollection,
      docId: uid,
      data: data,
    );
  }

  /// Update FCM token.
  Future<void> updateFcmToken(String uid, String token) async {
    await updateUser(uid, {'fcmToken': token});
  }

  /// Update last active timestamp.
  Future<void> updateLastActive(String uid) async {
    await updateUser(uid, {
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  /// Set couple ID and partner ID on user.
  Future<void> pairUser({
    required String uid,
    required String coupleId,
    required String partnerId,
  }) async {
    await updateUser(uid, {
      'coupleId': coupleId,
      'partnerId': partnerId,
    });
  }

  /// Delete user profile.
  Future<void> deleteUser(String uid) async {
    await _db.delete(
      collection: AppConstants.usersCollection,
      docId: uid,
    );
  }
}
