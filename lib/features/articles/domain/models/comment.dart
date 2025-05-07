import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String articleId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;
  final int likes;
  final List<String> likedBy;

  Comment({
    required this.id,
    required this.articleId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.likedBy,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      articleId: data['articleId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articleId': articleId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'likedBy': likedBy,
    };
  }
}
