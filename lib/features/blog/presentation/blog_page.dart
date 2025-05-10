import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepro/core/widgets/blog_post.dart';
import 'dart:convert';

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
                      Positioned(
                        left: 16,
                        child: IconButton(
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
                      const SizedBox(
                        width: 56,
                      ), // Pour équilibrer le bouton retour
                    ],
                  ),
                  const SizedBox(height: 40),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('articles')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final articles = snapshot.data?.docs ?? [];

                      if (articles.isEmpty) {
                        return const Center(
                          child: Text(
                            'Aucun article pour le moment',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        );
                      }

                      return Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width < 600
                                    ? 5
                                    : 10,
                          ),
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: Column(
                            children:
                                articles.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  final mainImage =
                                      data['mainImage'] != null
                                          ? base64Decode(data['mainImage'])
                                          : null;

                                  return BlogPostCard(
                                    id: doc.id,
                                    title: data['title'] ?? '',
                                    content: data['content'] ?? '',
                                    mainImage: mainImage,
                                    createdAt:
                                        (data['createdAt'] as Timestamp)
                                            .toDate(),
                                    likes: data['likes'] ?? 0,
                                    comments: data['comments'] ?? 0,
                                    shares: data['shares'] ?? 0,
                                    authorEmail: data['authorEmail'] ?? '',
                                  );
                                }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
