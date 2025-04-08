import 'package:flutter/material.dart';
import 'package:notepro/routes/routes.dart';
import 'package:notepro/core/widgets/responsive_navbar.dart';
import 'package:notepro/core/widgets/landing_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: const Text(
            'Souscrivez à notre newsletter pour recevoir les dernières mises à jour !',
            style: TextStyle(
              color: Color(0xff98989A),
              fontSize: 12,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff141414),
        ),
      ),
      endDrawer: screenWidth <= 800 ? _buildMobileDrawer(context) : null,
      body: _buildBody(),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 95,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1F1F1F),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 50,
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
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(context, 'Accueil', 'home'),
                  _buildDrawerItem(context, 'Avis', 'reviews'),
                  _buildDrawerItem(context, 'Catégories', 'categories'),
                  const Divider(),
                  _buildDrawerItem(context, 'Connexion', Routes.login),
                  ListTile(
                    title: const Text('Espace Entreprise'),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () => _navigate(context, route),
    );
  }

  Widget _buildBody() {
    return const Column(
      children: [
        ResponsiveNavbar(currentPage: 'home'),
        Expanded(child: LandingPage()), // Ajout de Expanded ici
      ],
    );
  }

  void _navigate(BuildContext context, String routeName) {
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName);
  }
}