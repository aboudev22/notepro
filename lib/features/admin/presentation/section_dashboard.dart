import 'package:flutter/material.dart';
import 'package:notepro/features/articles/data/repositories/article_repository.dart';
import 'package:notepro/features/articles/domain/models/article.dart';
import 'package:notepro/features/admin/presentation/pages/create_edit_article_page.dart';

class SectionDashboard extends StatefulWidget {
  const SectionDashboard({super.key});

  @override
  State<SectionDashboard> createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard> {
  final ArticleRepository _articleRepository = ArticleRepository();
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    _articlesFuture = _articleRepository.getLatestArticles(limit: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Gestion des articles',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateEditArticlePage(),
                    ),
                  );
                  setState(() {
                    _loadArticles();
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Nouvel article'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _articlesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                final articles = snapshot.data ?? [];

                if (articles.isEmpty) {
                  return const Center(
                    child: Text('Aucun article pour le moment'),
                  );
                }

                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading:
                            article.imageUrl.isNotEmpty
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    article.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Icon(Icons.image),
                                ),
                        title: Text(article.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  article.isPublished
                                      ? Icons.published_with_changes
                                      : Icons.edit_note,
                                  size: 16,
                                  color:
                                      article.isPublished
                                          ? Colors.green
                                          : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  article.isPublished ? 'Publié' : 'Brouillon',
                                  style: TextStyle(
                                    color:
                                        article.isPublished
                                            ? Colors.green
                                            : Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${article.likes} likes',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Modifier'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Supprimer'),
                                ),
                              ],
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CreateEditArticlePage(
                                        article: article,
                                      ),
                                ),
                              );
                              setState(() {
                                _loadArticles();
                              });
                            } else if (value == 'delete') {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Supprimer l\'article'),
                                      content: const Text(
                                        'Êtes-vous sûr de vouloir supprimer cet article ?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Annuler'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Supprimer'),
                                        ),
                                      ],
                                    ),
                              );

                              if (confirmed == true) {
                                await _articleRepository.deleteArticle(
                                  article.id,
                                );
                                setState(() {
                                  _loadArticles();
                                });
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
