import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:notepro/features/admin/presentation/section_dashboard.dart';
import 'package:notepro/features/admin/widgets/admin_appbar.dart';
import 'package:notepro/features/admin/widgets/siderbar_dashboard.dart';
import 'package:notepro/core/theme/app_theme.dart';
import 'package:notepro/core/utils/date_formatter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedSection = 'Dashboard';
  bool _sidebarVisible = false;
  final GlobalKey<_DashboardPageState> _refreshKey = GlobalKey();

  void _selectSection(String section) {
    setState(() {
      _selectedSection = section;
      _sidebarVisible = false;
    });
  }

  void _refreshPage() {
    setState(() {});
  }

  Widget _buildSectionContent() {
    switch (_selectedSection) {
      case 'Dashboard':
        return const SectionDashboard();
      case 'articles':
        return const ArticlesSection();
      case 'notes':
        return const Center(
          child: Text('Page Notes', style: TextStyle(fontSize: 48)),
        );
      case 'stats':
        return const Center(
          child: Text('Page Stats', style: TextStyle(fontSize: 48)),
        );
      case 'marketing':
        return const Center(
          child: Text('Page Marketing', style: TextStyle(fontSize: 48)),
        );
      case 'viewers':
        return const Center(
          child: Text('Page Viewers', style: TextStyle(fontSize: 48)),
        );
      case 'commentaires':
        return const Center(
          child: Text('Page Commentaires', style: TextStyle(fontSize: 48)),
        );
      case 'aide':
        return const Center(
          child: Text('Page Aide', style: TextStyle(fontSize: 48)),
        );
      default:
        return const Center(
          child: Text('Section inconnue', style: TextStyle(fontSize: 48)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AdminAppBar(
        onRefresh: _refreshPage,
        onCreateArticle: () => Navigator.pushNamed(context, '/create-article'),
      ),
      drawer:
          isDesktop
              ? null
              : Drawer(
                child: DashboardSidebar(
                  onSectionSelected: _selectSection,
                  selectedSection: _selectedSection,
                  isCollapsed: true,
                  onClose: () => Navigator.pop(context),
                ),
              ),
      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              onSectionSelected: _selectSection,
              selectedSection: _selectedSection,
              onClose: () {},
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        (isMobile ? 56 : 64),
                  ),
                  child: _buildSectionContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticlesSection extends StatelessWidget {
  const ArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1000;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Articles',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                  fontSize: isMobile ? 24 : null,
                ),
              ),
              ElevatedButton.icon(
                onPressed:
                    () => Navigator.pushNamed(context, '/create-article'),
                icon: const Icon(Icons.add),
                label: Text(
                  'Nouvel article',
                  style: TextStyle(fontSize: isMobile ? 12 : 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 20,
                    vertical: isMobile ? 8 : 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                  crossAxisSpacing: isMobile ? 16 : 24,
                  mainAxisSpacing: isMobile ? 16 : 24,
                  childAspectRatio: isMobile ? 1.2 : 0.8,
                ),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final doc = articles[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final mainImage =
                      data['mainImage'] != null
                          ? base64Decode(data['mainImage'] as String)
                          : null;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (mainImage != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.memory(
                              mainImage,
                              height: isMobile ? 150 : 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.all(isMobile ? 12 : 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] ?? '',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                  fontSize: isMobile ? 16 : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data['content'] ?? '',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.secondaryColor,
                                  fontSize: isMobile ? 12 : null,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: isMobile ? 12 : 16,
                                        color: AppTheme.secondaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormatter.format(
                                          (data['createdAt'] as Timestamp)
                                              .toDate(),
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.secondaryColor,
                                          fontSize: isMobile ? 10 : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.comment,
                                        size: isMobile ? 12 : 16,
                                        color: AppTheme.secondaryColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${data['comments'] ?? 0}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.secondaryColor,
                                          fontSize: isMobile ? 10 : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
