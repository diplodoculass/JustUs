import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a registered user in the JustUs app.
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String? coupleId;
  final String? partnerId;
  final DateTime createdAt;
  final DateTime? lastActive;
  final String? fcmToken;
  final Map<String, bool> notificationPreferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.coupleId,
    this.partnerId,
    required this.createdAt,
    this.lastActive,
    this.fcmToken,
    this.notificationPreferences = const {},
  });

  /// Whether this user has a partner paired
  bool get isPaired => coupleId != null && partnerId != null;

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? coupleId,
    String? partnerId,
    DateTime? createdAt,
    DateTime? lastActive,
    String? fcmToken,
    Map<String, bool>? notificationPreferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coupleId: coupleId ?? this.coupleId,
      partnerId: partnerId ?? this.partnerId,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      fcmToken: fcmToken ?? this.fcmToken,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
      coupleId: data['coupleId'] as String?,
      partnerId: data['partnerId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as Timestamp).toDate()
          : null,
      fcmToken: data['fcmToken'] as String?,
      notificationPreferences:
          (data['notificationPreferences'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v as bool)) ??
              {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'coupleId': coupleId,
      'partnerId': partnerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive':
          lastActive != null ? Timestamp.fromDate(lastActive!) : null,
      'fcmToken': fcmToken,
      'notificationPreferences': notificationPreferences,
    };
  }
}
