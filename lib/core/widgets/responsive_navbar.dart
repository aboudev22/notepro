import 'package:flutter/material.dart';
import 'package:notepro/routes/routes.dart'; 


class ResponsiveNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPage;
  const ResponsiveNavbar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 800) {
      return _buildDesktopNavbar(context);
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: const Color(0xFF1F1F1F),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 50, // Adjust the size as needed
                    width: 50,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'notepro',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Burger menu
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDesktopNavbar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1a1a1a),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Logo
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 50, // Adjust the size as needed
                    width: 50,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'notepro',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
            ),
          ),

          // Navigation links
          Row(
            children: [
              _navButton('home', 'Accueil', context),
              const SizedBox(width: 12),
              _navButton('reviews', 'Avis', context),
              const SizedBox(width: 12),
              _navButton('categories', 'Catégories', context),
            ],
          ),

          // Auth buttons
          Row(
            children: [
              TextButton(
                onPressed: () {
                    // Navigation vers la page de connexion
                    Navigator.pushNamed(context, Routes.login);
                },
                child: const Text('Connexion', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFF56E0F)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
                  overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.1)),
                ),
                child: const Text(
                  'Espace Entreprise',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _navButton(String pageKey, String label, BuildContext context) {
    final bool isActive = currentPage == pageKey;
    return TextButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
            isActive ? Colors.black : Colors.transparent),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
        overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

