import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../shared/models/journal_model.dart';

import '../../home/controllers/couple_repository.dart';

/// Provider for the journal repository.
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(
    ref.watch(firestoreServiceProvider),
    ref.watch(authServiceProvider),
  );
});

/// Stream all journal entries for the current couple.
final journalEntriesProvider =
    StreamProvider<List<JournalEntryModel>>((ref) {
  final couple = ref.watch(currentCoupleProvider).valueOrNull;
  if (couple == null) return Stream.value([]);

  return ref
      .watch(journalRepositoryProvider)
      .streamEntries(couple.id);
});

class JournalRepository {
  final FirestoreService _db;
  final AuthService _auth;

  JournalRepository(this._db, this._auth);

  /// Create a new journal entry.
  Future<String> createEntry({
    required String coupleId,
    required String authorName,
    required String content,
    String? mood,
    List<String> photoUrls = const [],
    bool isPrivate = false,
  }) async {
    final uid = _auth.uid!;
    final doc = await _db.create(
      collection: AppConstants.journalEntriesCollection,
      data: JournalEntryModel(
        id: '',
        coupleId: coupleId,
        authorId: uid,
        authorName: authorName,
        content: content,
        mood: mood,
        photoUrls: photoUrls,
        createdAt: DateTime.now(),
        isPrivate: isPrivate,
      ).toFirestore(),
    );
    return doc.id;
  }

  /// Stream entries for a couple (excludes partner's private entries).
  Stream<List<JournalEntryModel>> streamEntries(String coupleId) {
    final uid = _auth.uid;
    return _db
        .streamWhere(
          collection: AppConstants.journalEntriesCollection,
          field: 'coupleId',
          isEqualTo: coupleId,
          orderBy: 'createdAt',
          descending: true,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntryModel.fromFirestore(doc))
            .where((entry) =>
                !entry.isPrivate || entry.authorId == uid)
            .toList());
  }

  /// Get a single entry.
  Future<JournalEntryModel?> getEntry(String entryId) async {
    final doc = await _db.get(
      collection: AppConstants.journalEntriesCollection,
      docId: entryId,
    );
    if (!doc.exists) return null;
    return JournalEntryModel.fromFirestore(doc);
  }

  /// Delete a journal entry.
  Future<void> deleteEntry(String entryId) async {
    await _db.delete(
      collection: AppConstants.journalEntriesCollection,
      docId: entryId,
    );
  }

  /// Add a reply to a journal entry.
  Future<void> addReply({
    required String journalEntryId,
    required String authorName,
    required String content,
  }) async {
    final uid = _auth.uid!;
    await _db.create(
      collection: AppConstants.journalRepliesCollection,
      data: JournalReplyModel(
        id: '',
        journalEntryId: journalEntryId,
        authorId: uid,
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
      ).toFirestore(),
    );
  }

  /// Stream replies for a journal entry.
  Stream<List<JournalReplyModel>> streamReplies(String journalEntryId) {
    return _db
        .streamWhere(
          collection: AppConstants.journalRepliesCollection,
          field: 'journalEntryId',
          isEqualTo: journalEntryId,
          orderBy: 'createdAt',
          descending: false,
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalReplyModel.fromFirestore(doc))
            .toList());
  }
}
