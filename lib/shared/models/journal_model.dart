import 'package:cloud_firestore/cloud_firestore.dart';

/// A journal entry written by one partner.
class JournalEntryModel {
  final String id;
  final String coupleId;
  final String authorId;
  final String authorName;
  final String content;
  final String? mood;
  final List<String> photoUrls;
  final DateTime createdAt;
  final bool isPrivate;

  const JournalEntryModel({
    required this.id,
    required this.coupleId,
    required this.authorId,
    required this.authorName,
    required this.content,
    this.mood,
    this.photoUrls = const [],
    required this.createdAt,
    this.isPrivate = false,
  });

  factory JournalEntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntryModel(
      id: doc.id,
      coupleId: data['coupleId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      content: data['content'] as String? ?? '',
      mood: data['mood'] as String?,
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPrivate: data['isPrivate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'coupleId': coupleId,
        'authorId': authorId,
        'authorName': authorName,
        'content': content,
        'mood': mood,
        'photoUrls': photoUrls,
        'createdAt': Timestamp.fromDate(createdAt),
        'isPrivate': isPrivate,
      };

  JournalEntryModel copyWith({
    String? id,
    String? coupleId,
    String? authorId,
    String? authorName,
    String? content,
    String? mood,
    List<String>? photoUrls,
    DateTime? createdAt,
    bool? isPrivate,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      coupleId: coupleId ?? this.coupleId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      photoUrls: photoUrls ?? this.photoUrls,
      createdAt: createdAt ?? this.createdAt,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}

/// A reply to a journal entry.
class JournalReplyModel {
  final String id;
  final String journalEntryId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const JournalReplyModel({
    required this.id,
    required this.journalEntryId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory JournalReplyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalReplyModel(
      id: doc.id,
      journalEntryId: data['journalEntryId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? '',
      content: data['content'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'journalEntryId': journalEntryId,
        'authorId': authorId,
        'authorName': authorName,
        'content': content,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
