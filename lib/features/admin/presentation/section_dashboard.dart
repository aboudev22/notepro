import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepro/core/theme/app_theme.dart';

class SectionDashboard extends StatelessWidget {
  const SectionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1000;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tableau de bord',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 32),
          _DashboardStats(isMobile: isMobile, isTablet: isTablet),
        ],
      ),
    );
  }
}

class _DashboardStats extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;

  const _DashboardStats({required this.isMobile, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return Center(child: Text('Erreur: ${userSnapshot.error}'));
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('articles').snapshots(),
          builder: (context, articleSnapshot) {
            if (articleSnapshot.hasError) {
              return Center(child: Text('Erreur: ${articleSnapshot.error}'));
            }

            return FutureBuilder<Map<String, int>>(
              future: _getStats(),
              builder: (context, statsSnapshot) {
                if (statsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.count(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.5,
                  children: [
                    _StatCard(
                      title: 'Utilisateurs',
                      value:
                          userSnapshot.hasData
                              ? userSnapshot.data!.size.toString()
                              : '0',
                      icon: Icons.people,
                      color: AppTheme.primaryColor,
                    ),
                    _StatCard(
                      title: 'Articles',
                      value:
                          articleSnapshot.hasData
                              ? articleSnapshot.data!.size.toString()
                              : '0',
                      icon: Icons.article,
                      color: Colors.green,
                    ),
                    _StatCard(
                      title: 'Commentaires',
                      value:
                          statsSnapshot.hasData
                              ? statsSnapshot.data!['comments'].toString()
                              : '0',
                      icon: Icons.comment,
                      color: Colors.orange,
                    ),
                    _StatCard(
                      title: 'Likes',
                      value:
                          statsSnapshot.hasData
                              ? statsSnapshot.data!['likes'].toString()
                              : '0',
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                    _StatCard(
                      title: 'Partages',
                      value:
                          statsSnapshot.hasData
                              ? statsSnapshot.data!['shares'].toString()
                              : '0',
                      icon: Icons.share,
                      color: Colors.purple,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Map<String, int>> _getStats() async {
    int totalComments = 0;
    int totalLikes = 0;
    int totalShares = 0;

    try {
      final articlesSnapshot =
          await FirebaseFirestore.instance.collection('articles').get();

      for (var doc in articlesSnapshot.docs) {
        final data = doc.data();
        totalLikes += (data['likes'] as num?)?.toInt() ?? 0;
        totalShares += (data['shares'] as num?)?.toInt() ?? 0;

        final commentsSnapshot =
            await doc.reference.collection('comments').get();
        totalComments += commentsSnapshot.docs.length;
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des statistiques: $e');
    }

    return {
      'comments': totalComments,
      'likes': totalLikes,
      'shares': totalShares,
    };
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
