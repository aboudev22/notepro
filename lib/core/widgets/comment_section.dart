import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notepro/core/theme/app_theme.dart';
import 'package:notepro/core/utils/date_formatter.dart';

class CommentSection extends StatefulWidget {
  final String articleId;

  const CommentSection({Key? key, required this.articleId}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitComment() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? _emailController.text.trim();
    final comment = _commentController.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le commentaire ne peut pas être vide')),
      );
      return;
    }

    if (user == null && email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre email')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.articleId)
          .collection('comments')
          .add({
            'content': comment,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
            'userId': user?.uid,
          });

      _commentController.clear();
      _emailController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Commentaire ajouté avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (FirebaseAuth.instance.currentUser == null) ...[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Votre email',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: AppTheme.secondaryColor),
            ),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _commentController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Votre commentaire',
            border: const OutlineInputBorder(),
            labelStyle: TextStyle(color: AppTheme.secondaryColor),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitComment,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child:
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Publier le commentaire'),
        ),
        const SizedBox(height: 24),
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('articles')
                  .doc(widget.articleId)
                  .collection('comments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final comments = snapshot.data?.docs ?? [];

            if (comments.isEmpty) {
              return Text(
                'Aucun commentaire pour le moment',
                style: TextStyle(color: AppTheme.secondaryColor, fontSize: 16),
              );
            }

            return Column(
              children:
                  comments.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['email'] ?? 'Anonyme',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                data['createdAt'] != null
                                    ? DateFormatter.format(
                                      (data['createdAt'] as Timestamp).toDate(),
                                    )
                                    : '',
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(data['content'] ?? ''),
                        ],
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ],
    );
  }
}
