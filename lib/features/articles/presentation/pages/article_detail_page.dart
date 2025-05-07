import 'package:flutter/material.dart';
import 'package:notepro/features/articles/data/repositories/article_repository.dart';
import 'package:notepro/features/articles/domain/models/article.dart';
import 'package:notepro/features/articles/presentation/widgets/comments_section.dart';
import 'package:share_plus/share_plus.dart';

class ArticleDetailPage extends StatefulWidget {
  final String articleId;

  const ArticleDetailPage({super.key, required this.articleId});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final ArticleRepository _articleRepository = ArticleRepository();
  late Future<Article> _articleFuture;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _articleFuture = _articleRepository.getArticleById(widget.articleId);
  }

  void _toggleLike() async {
    // TODO: Remplacer par l'ID de l'utilisateur connecté
    const userId = 'current_user_id';
    await _articleRepository.toggleLike(widget.articleId, userId);
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _articleFuture.then((article) {
                Share.share(
                  'Découvrez cet article : ${article.title}\n\n${article.summary}\n\nLire la suite sur notre blog !',
                  subject: article.title,
                );
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Article>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final article = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (article.imageUrl.isNotEmpty)
                  Image.network(
                    article.imageUrl,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Par ${article.authorName}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Publié le ${article.publishedAt.day}/${article.publishedAt.month}/${article.publishedAt.year}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        article.content,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : null,
                            ),
                            onPressed: _toggleLike,
                          ),
                          Text('${article.likes} likes'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      CommentsSection(
                        articleId: article.id,
                        currentUserId:
                            'current_user_id', // TODO: Remplacer par l'ID de l'utilisateur connecté
                        currentUserName:
                            'Utilisateur', // TODO: Remplacer par le nom de l'utilisateur connecté
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
