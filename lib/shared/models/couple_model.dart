import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a paired couple in the app.
class CoupleModel {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime relationshipStartDate;
  final DateTime pairedAt;
  final int streakCount;
  final DateTime? lastStreakDate;
  final int streakFreezes;
  final bool isActive;

  const CoupleModel({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.relationshipStartDate,
    required this.pairedAt,
    this.streakCount = 0,
    this.lastStreakDate,
    this.streakFreezes = 0,
    this.isActive = true,
  });

  /// Get the partner ID given the current user ID
  String getPartnerId(String currentUserId) {
    return currentUserId == user1Id ? user2Id : user1Id;
  }

  CoupleModel copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? relationshipStartDate,
    DateTime? pairedAt,
    int? streakCount,
    DateTime? lastStreakDate,
    int? streakFreezes,
    bool? isActive,
  }) {
    return CoupleModel(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      relationshipStartDate:
          relationshipStartDate ?? this.relationshipStartDate,
      pairedAt: pairedAt ?? this.pairedAt,
      streakCount: streakCount ?? this.streakCount,
      lastStreakDate: lastStreakDate ?? this.lastStreakDate,
      streakFreezes: streakFreezes ?? this.streakFreezes,
      isActive: isActive ?? this.isActive,
    );
  }

  factory CoupleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoupleModel(
      id: doc.id,
      user1Id: data['user1Id'] as String,
      user2Id: data['user2Id'] as String,
      relationshipStartDate:
          (data['relationshipStartDate'] as Timestamp).toDate(),
      pairedAt: (data['pairedAt'] as Timestamp).toDate(),
      streakCount: (data['streakCount'] as num?)?.toInt() ?? 0,
      lastStreakDate: data['lastStreakDate'] != null
          ? (data['lastStreakDate'] as Timestamp).toDate()
          : null,
      streakFreezes: (data['streakFreezes'] as num?)?.toInt() ?? 0,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user1Id': user1Id,
      'user2Id': user2Id,
      'relationshipStartDate': Timestamp.fromDate(relationshipStartDate),
      'pairedAt': Timestamp.fromDate(pairedAt),
      'streakCount': streakCount,
      'lastStreakDate':
          lastStreakDate != null ? Timestamp.fromDate(lastStreakDate!) : null,
      'streakFreezes': streakFreezes,
      'isActive': isActive,
    };
  }
}
