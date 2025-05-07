import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String imageUrl;
  final DateTime publishedAt;
  final String authorId;
  final String authorName;
  final int likes;
  final List<String> likedBy;
  final bool isPublished;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.imageUrl,
    required this.publishedAt,
    required this.authorId,
    required this.authorName,
    required this.likes,
    required this.likedBy,
    required this.isPublished,
  });

  factory Article.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      summary: data['summary'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      publishedAt: (data['publishedAt'] as Timestamp).toDate(),
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      isPublished: data['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'summary': summary,
      'imageUrl': imageUrl,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'authorId': authorId,
      'authorName': authorName,
      'likes': likes,
      'likedBy': likedBy,
      'isPublished': isPublished,
    };
  }
}
