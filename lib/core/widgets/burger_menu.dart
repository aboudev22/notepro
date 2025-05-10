import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:notepro/features/auth/presentation/providers/auth_provider.dart';
import 'package:notepro/routes/routes.dart';

class BurgerMenu extends StatelessWidget {
  final bool visible;

  const BurgerMenu({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {}, // Empêche la propagation du tap
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/logo.png', width: 50, height: 50),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            _MenuItem(
                              text: 'Blog',
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, Routes.blog);
                              },
                            ),
                            const SizedBox(height: 16),
                            _MenuItem(
                              text: 'Contacts',
                              onTap: () {
                                Navigator.pop(context);
                                // TODO: Naviguer vers la page de contacts
                              },
                            ),
                            const SizedBox(height: 16),
                            if (authProvider.isAuthenticated) ...[
                              if (authProvider.isAdmin)
                                _MenuItem(
                                  text: 'Dashboard',
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      Routes.adminDashboard,
                                    );
                                  },
                                  color: Colors.blue,
                                ),
                              const SizedBox(height: 16),
                              _MenuItem(
                                text: 'Déconnexion',
                                onTap: () {
                                  Navigator.pop(context);
                                  authProvider.signOut();
                                },
                                color: Colors.red,
                              ),
                            ] else ...[
                              _MenuItem(
                                text: 'Connexion',
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, Routes.login);
                                },
                              ),
                              const SizedBox(height: 16),
                              _MenuItem(
                                text: 'Inscription',
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, Routes.signup);
                                },
                              ),
                            ],
                            const SizedBox(height: 16),
                            _MenuItem(
                              text: 'Rédiger un avis',
                              onTap: () {
                                Navigator.pop(context);
                                // TODO: Naviguer vers la page de rédaction d'avis
                              },
                              color: Colors.black,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({required this.text, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          text,
          style: TextStyle(
            color: color ?? Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
          ),
        ),
      ),
    );
  }
}
