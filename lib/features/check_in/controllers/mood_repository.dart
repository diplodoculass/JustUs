import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/mood_model.dart';

import '../../home/controllers/couple_repository.dart';

/// Provider for the mood repository.
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository(
    ref.watch(firestoreServiceProvider),
    ref.watch(authServiceProvider),
  );
});

/// Stream today's mood entries for the couple.
final todaysMoodsProvider = StreamProvider<List<MoodEntryModel>>((ref) {
  final couple = ref.watch(currentCoupleProvider).valueOrNull;
  if (couple == null) return Stream.value([]);

  return ref.watch(moodRepositoryProvider).streamTodaysMoods(couple.id);
});

/// Stream mood history for the couple (last 30 days).
final moodHistoryProvider = StreamProvider<List<MoodEntryModel>>((ref) {
  final couple = ref.watch(currentCoupleProvider).valueOrNull;
  if (couple == null) return Stream.value([]);

  return ref.watch(moodRepositoryProvider).streamMoodHistory(couple.id);
});

class MoodRepository {
  final FirestoreService _db;
  final AuthService _auth;

  MoodRepository(this._db, this._auth);

  /// Submit a mood check-in.
  Future<void> submitMood({
    required String coupleId,
    required String userName,
    required String mood,
    String? note,
    int energyLevel = 3,
  }) async {
    final uid = _auth.uid!;
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    await _db.set(
      collection: AppConstants.checkInsCollection,
      docId: '${coupleId}_${uid}_$dateKey',
      data: MoodEntryModel(
        id: '',
        coupleId: coupleId,
        userId: uid,
        userName: userName,
        mood: mood,
        note: note,
        energyLevel: energyLevel,
        createdAt: today,
      ).toFirestore(),
      merge: false,
    );
  }

  /// Stream today's moods for the couple.
  Stream<List<MoodEntryModel>> streamTodaysMoods(String coupleId) {
    return _db
        .streamWhere(
          collection: AppConstants.checkInsCollection,
          field: 'coupleId',
          isEqualTo: coupleId,
        )
        .map((snapshot) {
      final now = DateTime.now();
      return snapshot.docs
          .map((doc) => MoodEntryModel.fromFirestore(doc))
          .where((m) =>
              m.createdAt.year == now.year &&
              m.createdAt.month == now.month &&
              m.createdAt.day == now.day)
          .toList();
    });
  }

  /// Stream mood history (recent entries).
  Stream<List<MoodEntryModel>> streamMoodHistory(String coupleId) {
    return _db
        .streamWhere(
          collection: AppConstants.checkInsCollection,
          field: 'coupleId',
          isEqualTo: coupleId,
          orderBy: 'createdAt',
          descending: true,
          limit: 60,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => MoodEntryModel.fromFirestore(doc))
            .toList());
  }

  /// Check if user already submitted mood today.
  Future<bool> hasSubmittedToday(String coupleId) async {
    final uid = _auth.uid!;
    final today = DateTime.now();
    final dateKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final doc = await _db.get(
      collection: AppConstants.checkInsCollection,
      docId: '${coupleId}_${uid}_$dateKey',
    );
    return doc.exists;
  }
}
