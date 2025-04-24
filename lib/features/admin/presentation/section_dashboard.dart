import 'package:flutter/material.dart';
import 'package:notepro/features/admin/widgets/responsive_reordable.dart';

class SectionDashboard extends StatelessWidget {
  const SectionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ResponsiveReorderableWrap(),
                    const SizedBox(height: 24),
                    const Text(
                      'Articles publiés récemment',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Liste d’articles
                    ...List.generate(5, (index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text('Article ${index + 1}'),
                          subtitle: const Text('Publié le 24 avril 2025'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Action sur l’article
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
