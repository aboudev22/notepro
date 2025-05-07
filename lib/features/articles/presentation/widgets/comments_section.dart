import 'package:flutter/material.dart';
import 'package:notepro/features/articles/data/repositories/article_repository.dart';
import 'package:notepro/features/articles/domain/models/comment.dart';

class CommentsSection extends StatefulWidget {
  final String articleId;
  final String currentUserId;
  final String currentUserName;

  const CommentsSection({
    super.key,
    required this.articleId,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final ArticleRepository _articleRepository = ArticleRepository();
  final TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    _commentsFuture = _articleRepository.getCommentsForArticle(
      widget.articleId,
    );
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final comment = Comment(
      id: '', // Will be set by Firestore
      articleId: widget.articleId,
      userId: widget.currentUserId,
      userName: widget.currentUserName,
      content: _commentController.text.trim(),
      createdAt: DateTime.now(),
      likes: 0,
      likedBy: [],
    );

    await _articleRepository.addComment(comment);
    _commentController.clear();
    setState(() {
      _loadComments();
    });
  }

  Future<void> _toggleCommentLike(String commentId) async {
    await _articleRepository.toggleCommentLike(commentId, widget.currentUserId);
    setState(() {
      _loadComments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Ajouter un commentaire...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _addComment,
                child: const Text('Publier'),
              ),
            ],
          ),
        ),
        FutureBuilder<List<Comment>>(
          future: _commentsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            final comments = snapshot.data ?? [];

            if (comments.isEmpty) {
              return const Center(
                child: Text('Aucun commentaire pour le moment'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final isLiked = comment.likedBy.contains(widget.currentUserId);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${comment.createdAt.day}/${comment.createdAt.month}/${comment.createdAt.year}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(comment.content),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked ? Colors.red : null,
                              ),
                              onPressed: () => _toggleCommentLike(comment.id),
                            ),
                            Text('${comment.likes}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
