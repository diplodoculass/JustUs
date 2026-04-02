import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/data/prompt_seed_data.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/prompt_model.dart';

import '../../home/controllers/couple_repository.dart';

/// Provider for the daily prompt repository.
final dailyPromptRepositoryProvider = Provider<DailyPromptRepository>((ref) {
  return DailyPromptRepository(
    ref.watch(firestoreServiceProvider),
    ref.watch(authServiceProvider),
  );
});

/// Today's prompt for the current couple.
final todaysPromptProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final couple = ref.watch(currentCoupleProvider).valueOrNull;
  if (couple == null) return null;

  final daysTogether = DateTime.now()
      .difference(couple.relationshipStartDate)
      .inDays + 1;
  final promptData = PromptSeedData.getPromptForDay(daysTogether);

  return {
    'question': promptData['question'],
    'category': promptData['category'],
    'dayNumber': daysTogether,
  };
});

/// Stream of responses for today's prompt.
final todaysResponsesProvider =
    StreamProvider<List<PromptResponseModel>>((ref) {
  final couple = ref.watch(currentCoupleProvider).valueOrNull;
  if (couple == null) return Stream.value([]);

  final daysTogether = DateTime.now()
      .difference(couple.relationshipStartDate)
      .inDays + 1;
  final promptId = 'day_$daysTogether';

  return ref
      .watch(dailyPromptRepositoryProvider)
      .streamResponses(couple.id, promptId);
});

class DailyPromptRepository {
  final FirestoreService _db;
  final AuthService _auth;

  DailyPromptRepository(this._db, this._auth);

  /// Submit a response to today's prompt.
  Future<void> submitResponse({
    required String coupleId,
    required int dayNumber,
    required String answer,
  }) async {
    final uid = _auth.uid!;
    final promptId = 'day_$dayNumber';

    await _db.set(
      collection: AppConstants.promptResponsesCollection,
      docId: '${coupleId}_${promptId}_$uid',
      data: {
        'promptId': promptId,
        'coupleId': coupleId,
        'userId': uid,
        'answer': answer,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      },
      merge: false,
    );
  }

  /// Stream responses for a prompt within a couple.
  Stream<List<PromptResponseModel>> streamResponses(
    String coupleId,
    String promptId,
  ) {
    return _db
        .streamWhere(
          collection: AppConstants.promptResponsesCollection,
          field: 'coupleId',
          isEqualTo: coupleId,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => PromptResponseModel.fromFirestore(doc))
            .where((r) => r.promptId == promptId)
            .toList());
  }

  /// Add a reaction to a partner's response.
  Future<void> addReaction({
    required String responseId,
    required String reaction,
  }) async {
    await _db.update(
      collection: AppConstants.promptResponsesCollection,
      docId: responseId,
      data: {'reaction': reaction},
    );
  }

  /// Get past responses for history view.
  Future<List<PromptResponseModel>> getPastResponses(String coupleId) async {
    final snapshot = await _db.query(
      collection: AppConstants.promptResponsesCollection,
      field: 'coupleId',
      isEqualTo: coupleId,
      orderBy: 'createdAt',
      descending: true,
      limit: 60,
    );
    return snapshot.docs
        .map((doc) => PromptResponseModel.fromFirestore(doc))
        .toList();
  }
}
