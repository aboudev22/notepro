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
import 'package:notepro/core/widgets/comment_section.dart';
import 'package:notepro/core/widgets/loading_indicator.dart';
import 'package:notepro/core/widgets/error_message.dart';
import 'package:notepro/core/theme/app_theme.dart';
import 'package:notepro/core/utils/date_formatter.dart';

class ArticlePage extends StatelessWidget {
  final String articleId;

  const ArticlePage({Key? key, required this.articleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('articles')
                .doc(articleId)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorMessage(message: 'Une erreur est survenue');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const ErrorMessage(message: 'Article non trouvé');
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final title = data['title'] as String;
          final content = data['content'] as String;
          final author = data['authorEmail'] as String;
          final createdAt = (data['createdAt'] as Timestamp).toDate();
          final mainImage =
              data['mainImage'] != null
                  ? base64Decode(data['mainImage'] as String)
                  : null;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: isMobile ? 200 : (isTablet ? 300 : 400),
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background:
                      mainImage != null
                          ? Image.memory(mainImage, fit: BoxFit.cover)
                          : Container(color: AppTheme.primaryColor),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 800,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                          fontSize: isMobile ? 24 : (isTablet ? 32 : 40),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 16,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            author,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.secondaryColor),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppTheme.secondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.format(createdAt),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.secondaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: MarkdownBody(
                          data: content,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              height: 1.6,
                              color: AppTheme.textColor,
                            ),
                            h1: TextStyle(
                              fontSize: isMobile ? 24 : 32,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                            h2: TextStyle(
                              fontSize: isMobile ? 20 : 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                            h3: TextStyle(
                              fontSize: isMobile ? 18 : 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                            blockquote: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontStyle: FontStyle.italic,
                              color: AppTheme.secondaryColor,
                            ),
                            code: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              backgroundColor: Colors.grey[100],
                              color: AppTheme.textColor,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 24),
                      Text(
                        'Commentaires',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CommentSection(articleId: articleId),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
