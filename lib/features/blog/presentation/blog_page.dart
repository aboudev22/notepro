import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepro/core/widgets/blog_post.dart';
import 'dart:convert';
import 'dart:typed_data';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Blog',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 56), // Pour équilibrer le layout
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildArticlesList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('articles')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        // Gestion des erreurs
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        // État de chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        }

        // Données vides
        if (snapshot.data?.docs.isEmpty ?? true) {
          return const Center(
            child: Text(
              'Aucun article pour le moment',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        }

        // Construction de la liste
        return _buildArticlesGrid(snapshot.data!.docs);
      },
    );
  }

  Widget _buildArticlesGrid(List<QueryDocumentSnapshot> articles) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width < 600 ? 5 : 10,
        ),
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          children:
              articles.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                // Gestion sécurisée de l'image
                Uint8List? mainImage;
                if (data['mainImage'] != null) {
                  try {
                    mainImage = base64Decode(data['mainImage']);
                  } catch (e) {
                    debugPrint('Erreur de décodage d\'image: $e');
                  }
                }

                // Gestion sécurisée de la date
                DateTime createdAt;
                try {
                  createdAt = (data['createdAt'] as Timestamp).toDate();
                } catch (e) {
                  createdAt = DateTime.now();
                  debugPrint('Erreur de date: $e');
                }

                return BlogPostCard(
                  id: doc.id,
                  title: data['title'] ?? 'Titre non disponible',
                  content: data['content'] ?? 'Contenu non disponible',
                  mainImage: mainImage,
                  createdAt: createdAt,
                  likes: (data['likes'] as num?)?.toInt() ?? 0,
                  comments: (data['comments'] as num?)?.toInt() ?? 0,
                  shares: (data['shares'] as num?)?.toInt() ?? 0,
                  authorEmail: data['authorEmail'] ?? 'Auteur inconnu',
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          const Text(
            'Impossible de charger les articles',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(color: Colors.white54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () => setState(() {}),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
