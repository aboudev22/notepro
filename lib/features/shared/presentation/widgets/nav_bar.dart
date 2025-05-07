import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notepro/features/auth/presentation/providers/auth_provider.dart';
import 'package:notepro/features/admin/presentation/pages/admin_dashboard_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return AppBar(
          title: const Text('Notepro'),
          actions: [
            if (authProvider.isAuthenticated) ...[
              if (authProvider.isAdmin)
                IconButton(
                  icon: const Icon(Icons.dashboard),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminDashboardPage(),
                      ),
                    );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => authProvider.signOut(),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  // TODO: Naviguer vers la page de connexion
                },
                child: const Text('Connexion'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Naviguer vers la page d'inscription
                },
                child: const Text('Inscription'),
              ),
            ],
          ],
        );
      },
    );
  }
}
