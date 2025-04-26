import 'package:flutter/material.dart';

// Ton modèle que tu as défini
class BlogPost {
  final String id;
  final String title;
  final String description;
  final String content;
  final String image;
  final String author;
  final DateTime date;
  final List<String> categories;
  final int views;
  final List<String> tags;

  BlogPost({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.image,
    required this.author,
    required this.date,
    required this.categories,
    required this.views,
    required this.tags,
  });
}

// Une liste fictive d'articles
final List<BlogPost> blogPosts = [
  BlogPost(
    id: 'banking-security-2024',
    title:
        "Enquête sur les services bancaires mobiles au Cameroun : Fiabilité et Sécurité",
    description:
        "Notepro a mené une enquête approfondie pour évaluer la fiabilité et la sécurité des principales applications bancaires.",
    content: "Contenu complet ici...",
    image: "assets/images/0.png",
    author: "Notepro Team",
    date: DateTime(2024, 4, 15),
    categories: ["Technologie", "Finance"],
    views: 120,
    tags: ["banque", "sécurité", "mobile"],
  ),
  BlogPost(
    id: 'internet-home-2024',
    title:
        "Analyse des services internet à domicile : Quel fournisseur offre la meilleure performance ?",
    description:
        "Nous avons testé plusieurs fournisseurs pour vous aider à choisir le meilleur.",
    content: "Contenu complet ici...",
    image: "assets/images/1.png",
    author: "Notepro Team",
    date: DateTime(2024, 3, 1),
    categories: ["Technologie"],
    views: 80,
    tags: ["internet", "test", "fournisseur"],
  ),
];

class BlogListPage extends StatelessWidget {
  const BlogListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nos Articles de Blog'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: blogPosts.length,
        itemBuilder: (context, index) {
          final blog = blogPosts[index];
          return BlogCard(blog: blog);
        },
      ),
    );
  }
}

class BlogCard extends StatelessWidget {
  final BlogPost blog;

  const BlogCard({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Naviguer vers la page de détails
          // Navigator.push(...);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                blog.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    blog.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${blog.date.day}/${blog.date.month}/${blog.date.year}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.remove_red_eye,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${blog.views} vues",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
