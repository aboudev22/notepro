import 'package:flutter/material.dart';

class DashboardSidebar extends StatelessWidget {
  final Function(String) onSectionSelected;
  final bool isCollapsed;
  final VoidCallback onClose;
  final String selectedSection;

  const DashboardSidebar({
    super.key,
    required this.onSectionSelected,
    required this.selectedSection,
    this.isCollapsed = false,
    required this.onClose,
  });

  Widget buildNavButton({
    required IconData icon,
    required String label,
    required void Function() onTap,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow:
            isActive
                ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.black : Colors.grey[700],
        ),
        title: Text(
          label,
          style: TextStyle(color: isActive ? Colors.black : Colors.grey[700]),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: 250,
      height: double.infinity,
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "NotePro Admin",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Menu', style: TextStyle(fontWeight: FontWeight.w400)),
          ),
          buildNavButton(
            icon: Icons.article,
            label: 'Dashboard',
            isActive: selectedSection == 'Dashboard',
            onTap: () => onSectionSelected('Dashboard'),
          ),
          buildNavButton(
            icon: Icons.article,
            label: 'Articles',
            isActive: selectedSection == 'articles',
            onTap: () => onSectionSelected('articles'),
          ),
          buildNavButton(
            icon: Icons.note,
            label: 'Notes',
            isActive: selectedSection == 'notes',
            onTap: () => onSectionSelected('notes'),
          ),
          buildNavButton(
            icon: Icons.bar_chart,
            label: 'Stats',
            isActive: selectedSection == 'stats',
            onTap: () => onSectionSelected('stats'),
          ),
          buildNavButton(
            icon: Icons.campaign,
            label: 'Marketing',
            isActive: selectedSection == 'marketing',
            onTap: () => onSectionSelected('marketing'),
          ),
          buildNavButton(
            icon: Icons.people,
            label: 'Viewers',
            isActive: selectedSection == 'viewers',
            onTap: () => onSectionSelected('viewers'),
          ),
          buildNavButton(
            icon: Icons.comment,
            label: 'Commentaires',
            isActive: selectedSection == 'commentaires',
            onTap: () => onSectionSelected('commentaires'),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Autres',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          buildNavButton(
            icon: Icons.help_outline,
            label: 'Aide',
            isActive: selectedSection == 'aide',
            onTap: () => onSectionSelected('aide'),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Admin Doe', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );

    if (!isCollapsed) return content;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.grey[100]),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: 0,
          top: 0,
          bottom: 0,
          child: content,
        ),
      ],
    );
  }
}
