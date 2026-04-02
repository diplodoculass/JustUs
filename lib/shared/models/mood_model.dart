import 'package:cloud_firestore/cloud_firestore.dart';

/// A mood check-in entry for one user.
class MoodEntryModel {
  final String id;
  final String coupleId;
  final String userId;
  final String userName;
  final String mood; // emoji or short label
  final String? note;
  final int energyLevel; // 1-5
  final DateTime createdAt;

  const MoodEntryModel({
    required this.id,
    required this.coupleId,
    required this.userId,
    required this.userName,
    required this.mood,
    this.note,
    this.energyLevel = 3,
    required this.createdAt,
  });

  factory MoodEntryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MoodEntryModel(
      id: doc.id,
      coupleId: data['coupleId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      mood: data['mood'] as String? ?? '',
      note: data['note'] as String?,
      energyLevel: data['energyLevel'] as int? ?? 3,
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'coupleId': coupleId,
        'userId': userId,
        'userName': userName,
        'mood': mood,
        'note': note,
        'energyLevel': energyLevel,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  MoodEntryModel copyWith({
    String? id,
    String? coupleId,
    String? userId,
    String? userName,
    String? mood,
    String? note,
    int? energyLevel,
    DateTime? createdAt,
  }) {
    return MoodEntryModel(
      id: id ?? this.id,
      coupleId: coupleId ?? this.coupleId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      energyLevel: energyLevel ?? this.energyLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
