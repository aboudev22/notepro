import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  final VoidCallback onCreateArticle;

  const AdminAppBar({
    super.key,
    required this.onRefresh,
    required this.onCreateArticle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppBar(
      title: Text(
        'Administration',
        style: GoogleFonts.bricolageGrotesque(
          fontSize: isMobile ? 20 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, size: isMobile ? 20 : 24),
          onPressed: onRefresh,
          tooltip: 'Rafraîchir',
        ),
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: onCreateArticle,
              icon: const Icon(Icons.add),
              label: const Text('Nouvel article'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onCreateArticle,
            tooltip: 'Nouvel article',
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
