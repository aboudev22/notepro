import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:notepro/core/widgets/comment_section.dart';
import 'package:notepro/core/widgets/loading_indicator.dart';
import 'package:notepro/core/widgets/error_message.dart';
import 'package:notepro/core/theme/app_theme.dart';
import 'package:notepro/core/utils/date_formatter.dart';
import 'package:flutter/rendering.dart'; // Ajout de cet import pour ScrollDirection

class ArticlePage extends StatelessWidget {
  final String articleId;

  const ArticlePage({Key? key, required this.articleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1000;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Important pour éviter les rechargements
      body: KeyboardDismissOnScroll(
        child: CustomScrollView(
          physics:
              const ClampingScrollPhysics(), // Pour un défilement plus naturel sur mobile
          slivers: [
            SliverAppBar(
              expandedHeight: isMobile ? 200 : (isTablet ? 300 : 400),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: StreamBuilder<DocumentSnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('articles')
                          .doc(articleId)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.exists) {
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      final mainImage =
                          data['mainImage'] != null
                              ? base64Decode(data['mainImage'] as String)
                              : null;

                      return mainImage != null
                          ? Image.memory(mainImage, fit: BoxFit.cover)
                          : Container(color: AppTheme.primaryColor);
                    }
                    return Container(color: AppTheme.primaryColor);
                  },
                ),
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
              child: StreamBuilder<DocumentSnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('articles')
                        .doc(articleId)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const ErrorMessage(
                      message: 'Une erreur est survenue',
                    );
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

                  return Container(
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
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CommentSection(articleId: articleId),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardDismissOnScroll extends StatelessWidget {
  final Widget child;

  const KeyboardDismissOnScroll({Key? key, required this.child})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification &&
            notification.direction != ScrollDirection.idle) {
          FocusScope.of(context).unfocus();
        }
        return false;
      },
      child: child,
    );
  }
}
