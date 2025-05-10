import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ArticlePage extends StatefulWidget {
  final String articleId;

  const ArticlePage({Key? key, required this.articleId}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

      await FirebaseFirestore.instance
          .collection('articles')
          .doc(widget.articleId)
          .update({'comments': FieldValue.increment(1)});

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

  void _shareArticle(BuildContext context, Map<String, dynamic> data) {
    final String articleUrl = 'https://notepro.com/article/${widget.articleId}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Partager l\'article',
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareButton(
                      icon: Icons.copy,
                      label: 'Copier le lien',
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: articleUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Lien copié dans le presse-papiers'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                    _ShareButton(
                      icon: Icons.share,
                      label: 'Partager',
                      onTap: () {
                        Share.share(
                          'Découvrez cet article sur NotePro : $articleUrl',
                          subject: data['title'] ?? 'Article NotePro',
                        );
                        Navigator.pop(context);
                      },
                    ),
                    _ShareButton(
                      icon: Icons.mail,
                      label: 'Email',
                      onTap: () {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          queryParameters: {
                            'subject': data['title'] ?? 'Article NotePro',
                            'body':
                                'Découvrez cet article sur NotePro : $articleUrl',
                          },
                        );
                        launchUrl(emailLaunchUri);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ShareButton(
                      icon: Icons.facebook,
                      label: 'Facebook',
                      onTap: () {
                        final Uri facebookUri = Uri.parse(
                          'https://www.facebook.com/sharer/sharer.php?u=$articleUrl',
                        );
                        launchUrl(facebookUri);
                        Navigator.pop(context);
                      },
                    ),
                    _ShareButton(
                      icon: Icons.chat,
                      label: 'WhatsApp',
                      onTap: () {
                        final Uri whatsappUri = Uri.parse(
                          'https://wa.me/?text=Découvrez cet article sur NotePro : $articleUrl',
                        );
                        launchUrl(whatsappUri);
                        Navigator.pop(context);
                      },
                    ),
                    _ShareButton(
                      icon: Icons.language,
                      label: 'Twitter',
                      onTap: () {
                        final Uri twitterUri = Uri.parse(
                          'https://twitter.com/intent/tweet?text=Découvrez cet article sur NotePro : $articleUrl',
                        );
                        launchUrl(twitterUri);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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
                  StreamBuilder<DocumentSnapshot>(
                    stream:
                        _firestore
                            .collection('articles')
                            .doc(widget.articleId)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(child: Text('Article non trouvé'));
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _shareArticle(context, data),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (data['mainImage'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                base64Decode(data['mainImage']),
                                width: double.infinity,
                                height: 400,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            data['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Par ${data['authorEmail']} • ${DateFormat('dd/MM/yyyy').format((data['createdAt'] as Timestamp).toDate())}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: MarkdownBody(
                              data: data['content'] ?? '',
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.6,
                                ),
                                h1: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                                h2: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                h3: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
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
                                  fontSize: 16,
                                ),
                                code: const TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.black26,
                                  fontSize: 16,
                                ),
                                codeblockDecoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                listBullet: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                tableHead: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                tableBody: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              selectable: true,
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Divider(color: Colors.white30),
                          const SizedBox(height: 20),
                          Text(
                            'Commentaires',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_auth.currentUser == null) ...[
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Votre email',
                                labelStyle: TextStyle(color: Colors.white70),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                          ],
                          TextField(
                            controller: _commentController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Votre commentaire',
                              labelStyle: TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submitComment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text('Publier le commentaire'),
                          ),
                          const SizedBox(height: 20),
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                _firestore
                                    .collection('articles')
                                    .doc(widget.articleId)
                                    .collection('comments')
                                    .orderBy('createdAt', descending: true)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Erreur: ${snapshot.error}');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              final comments = snapshot.data?.docs ?? [];

                              if (comments.isEmpty) {
                                return const Text(
                                  'Aucun commentaire pour le moment',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                );
                              }

                              return Column(
                                children:
                                    comments.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 16,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  data['email'] ?? 'Anonyme',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  data['createdAt'] != null
                                                      ? DateFormat(
                                                        'dd/MM/yyyy',
                                                      ).format(
                                                        (data['createdAt']
                                                                as Timestamp)
                                                            .toDate(),
                                                      )
                                                      : '',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              data['content'] ?? '',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              );
                            },
                          ),
                        ],
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

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.bricolageGrotesque(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
