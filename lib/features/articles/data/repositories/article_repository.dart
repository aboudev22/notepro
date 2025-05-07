import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepro/features/articles/domain/models/article.dart';
import 'package:notepro/features/articles/domain/models/comment.dart';

class ArticleRepository {
  final FirebaseFirestore _firestore;
  final String _articlesCollection = 'articles';
  final String _commentsCollection = 'comments';

  ArticleRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Article>> getLatestArticles({int limit = 3}) async {
    try {
      final snapshot =
          await _firestore
              .collection(_articlesCollection)
              .where('isPublished', isEqualTo: true)
              .orderBy('publishedAt', descending: true)
              .limit(limit)
              .get();

      return snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch latest articles: $e');
    }
  }

  Future<Article> getArticleById(String id) async {
    try {
      final doc =
          await _firestore.collection(_articlesCollection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Article not found');
      }
      return Article.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch article: $e');
    }
  }

  Future<void> createArticle(Article article) async {
    try {
      await _firestore.collection(_articlesCollection).add(article.toMap());
    } catch (e) {
      throw Exception('Failed to create article: $e');
    }
  }

  Future<void> updateArticle(String id, Article article) async {
    try {
      await _firestore
          .collection(_articlesCollection)
          .doc(id)
          .update(article.toMap());
    } catch (e) {
      throw Exception('Failed to update article: $e');
    }
  }

  Future<void> deleteArticle(String id) async {
    try {
      await _firestore.collection(_articlesCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete article: $e');
    }
  }

  Future<void> toggleLike(String articleId, String userId) async {
    try {
      final docRef = _firestore.collection(_articlesCollection).doc(articleId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Article not found');
      }

      final article = Article.fromFirestore(doc);
      final likedBy = List<String>.from(article.likedBy);

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }

      await docRef.update({'likedBy': likedBy, 'likes': likedBy.length});
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  // Comment methods
  Future<List<Comment>> getCommentsForArticle(String articleId) async {
    try {
      final snapshot =
          await _firestore
              .collection(_commentsCollection)
              .where('articleId', isEqualTo: articleId)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<void> addComment(Comment comment) async {
    try {
      await _firestore.collection(_commentsCollection).add(comment.toMap());
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _firestore.collection(_commentsCollection).doc(commentId).delete();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  Future<void> toggleCommentLike(String commentId, String userId) async {
    try {
      final docRef = _firestore.collection(_commentsCollection).doc(commentId);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Comment not found');
      }

      final comment = Comment.fromFirestore(doc);
      final likedBy = List<String>.from(comment.likedBy);

      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }

      await docRef.update({'likedBy': likedBy, 'likes': likedBy.length});
    } catch (e) {
      throw Exception('Failed to toggle comment like: $e');
    }
  }
}
