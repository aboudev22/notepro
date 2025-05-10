import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notepro/core/models/blog.dart';
import 'package:notepro/core/constants.dart';
import 'package:notepro/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'package:flutter_markdown/flutter_markdown.dart';

class BlogPostCard extends StatefulWidget {
  final String id;
  final String title;
  final String content;
  final Uint8List? mainImage;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final String authorEmail;

  const BlogPostCard({
    super.key,
    required this.id,
    required this.title,
    required this.content,
    this.mainImage,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.authorEmail,
  });

  @override
  State<BlogPostCard> createState() => _BlogPostCardState();
}

class _BlogPostCardState extends State<BlogPostCard> {
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.id)
            .collection('likes')
            .doc(user.uid)
            .get();

    if (mounted) {
      setState(() {
        _isLiked = doc.exists;
      });
    }
  }

  Future<void> _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous devez être connecté pour liker un article'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final articleRef = FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.id);
      final likeRef = articleRef.collection('likes').doc(user.uid);

      if (_isLiked) {
        await likeRef.delete();
        await articleRef.update({'likes': FieldValue.increment(-1)});
      } else {
        await likeRef.set({'timestamp': FieldValue.serverTimestamp()});
        await articleRef.update({'likes': FieldValue.increment(1)});
      }

      if (mounted) {
        setState(() {
          _isLiked = !_isLiked;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _shareArticle() async {
    final url = 'https://notepro-32aa1.web.app/blog/${widget.id}';
    await Share.share(
      'Découvrez cet article : ${widget.title}\n$url',
      subject: widget.title,
    );

    // Incrémenter le compteur de partages
    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.id)
          .update({'shares': FieldValue.increment(1)});
    } catch (e) {
      debugPrint('Erreur lors de l\'incrémentation des partages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/article', arguments: widget.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.mainImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                child: Image.memory(
                  widget.mainImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Par ${widget.authorEmail} • ${DateFormat('dd/MM/yyyy').format(widget.createdAt)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: SingleChildScrollView(
                      child: MarkdownBody(
                        data:
                            widget.content.length > 200
                                ? '${widget.content.substring(0, 200)}...'
                                : widget.content,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width < 600
                                    ? 14
                                    : 16,
                            height: 1.5,
                          ),
                          h1: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width < 600
                                    ? 20
                                    : 24,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          h2: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width < 600
                                    ? 18
                                    : 20,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          h3: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.width < 600
                                    ? 16
                                    : 18,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                          strong: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          em: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          blockquote: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontStyle: FontStyle.italic,
                            fontSize:
                                MediaQuery.of(context).size.width < 600
                                    ? 12
                                    : 14,
                            backgroundColor: Colors.black12,
                            height: 1.5,
                          ),
                          code: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.black26,
                            fontSize:
                                MediaQuery.of(context).size.width < 600
                                    ? 12
                                    : 14,
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                          codeblockDecoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        selectable: true,
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : Colors.white,
                        ),
                        onPressed: _isLoading ? null : _toggleLike,
                      ),
                      Text(
                        '${widget.likes}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white),
                        onPressed: () {
                          // Navigation vers la page de l'article
                          Navigator.pushNamed(context, '/article/${widget.id}');
                        },
                      ),
                      Text(
                        '${widget.comments}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: _shareArticle,
                      ),
                      Text(
                        '${widget.shares}',
                        style: const TextStyle(color: Colors.white),
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
