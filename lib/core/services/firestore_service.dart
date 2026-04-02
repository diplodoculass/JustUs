import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestore service provider.
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService(FirebaseFirestore.instance);
});

/// Generic Firestore CRUD service.
class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService(this._db);

  FirebaseFirestore get instance => _db;

  // ─── Create ─────────────────────────────────────────────────────────

  /// Create a document with auto-generated ID.
  Future<DocumentReference> create({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    return await _db.collection(collection).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Set a document with a specific ID (creates or overwrites).
  Future<void> set({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    await _db.collection(collection).doc(docId).set(
      {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: merge),
    );
  }

  // ─── Read ───────────────────────────────────────────────────────────

  /// Get a single document by ID.
  Future<DocumentSnapshot> get({
    required String collection,
    required String docId,
  }) async {
    return await _db.collection(collection).doc(docId).get();
  }

  /// Get all documents in a collection.
  Future<QuerySnapshot> getAll({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query query = _db.collection(collection);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return await query.get();
  }

  /// Query documents with a where clause.
  Future<QuerySnapshot> query({
    required String collection,
    required String field,
    required dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query query = _db
        .collection(collection)
        .where(field, isEqualTo: isEqualTo);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return await query.get();
  }

  /// Stream a single document.
  Stream<DocumentSnapshot> streamDoc({
    required String collection,
    required String docId,
  }) {
    return _db.collection(collection).doc(docId).snapshots();
  }

  /// Stream a collection query.
  Stream<QuerySnapshot> streamCollection({
    required String collection,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _db.collection(collection);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  /// Stream a filtered collection.
  Stream<QuerySnapshot> streamWhere({
    required String collection,
    required String field,
    required dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query query = _db
        .collection(collection)
        .where(field, isEqualTo: isEqualTo);
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  // ─── Update ─────────────────────────────────────────────────────────

  /// Update specific fields on a document.
  Future<void> update({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collection).doc(docId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ─── Delete ─────────────────────────────────────────────────────────

  /// Delete a document.
  Future<void> delete({
    required String collection,
    required String docId,
  }) async {
    await _db.collection(collection).doc(docId).delete();
  }

  // ─── Batch / Transaction ────────────────────────────────────────────

  /// Run a batch write.
  WriteBatch batch() => _db.batch();

  /// Run a transaction.
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) handler,
  ) {
    return _db.runTransaction(handler);
  }
}
