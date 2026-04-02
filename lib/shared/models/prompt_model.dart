import 'package:cloud_firestore/cloud_firestore.dart';

/// A daily relationship prompt for the couple.
class PromptModel {
  final String id;
  final String question;
  final String category;
  final int dayNumber;

  const PromptModel({
    required this.id,
    required this.question,
    required this.category,
    required this.dayNumber,
  });

  factory PromptModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PromptModel(
      id: doc.id,
      question: data['question'] as String? ?? '',
      category: data['category'] as String? ?? 'General',
      dayNumber: data['dayNumber'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'question': question,
        'category': category,
        'dayNumber': dayNumber,
      };
}

/// A response to a prompt from one user.
class PromptResponseModel {
  final String id;
  final String promptId;
  final String coupleId;
  final String userId;
  final String answer;
  final DateTime createdAt;
  final String? reaction; // emoji reaction from partner

  const PromptResponseModel({
    required this.id,
    required this.promptId,
    required this.coupleId,
    required this.userId,
    required this.answer,
    required this.createdAt,
    this.reaction,
  });

  factory PromptResponseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PromptResponseModel(
      id: doc.id,
      promptId: data['promptId'] as String? ?? '',
      coupleId: data['coupleId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      answer: data['answer'] as String? ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reaction: data['reaction'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'promptId': promptId,
        'coupleId': coupleId,
        'userId': userId,
        'answer': answer,
        'createdAt': Timestamp.fromDate(createdAt),
        'reaction': reaction,
      };

  PromptResponseModel copyWith({
    String? id,
    String? promptId,
    String? coupleId,
    String? userId,
    String? answer,
    DateTime? createdAt,
    String? reaction,
  }) {
    return PromptResponseModel(
      id: id ?? this.id,
      promptId: promptId ?? this.promptId,
      coupleId: coupleId ?? this.coupleId,
      userId: userId ?? this.userId,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
      reaction: reaction ?? this.reaction,
    );
  }
}
