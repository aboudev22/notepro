import 'package:flutter/material.dart';
import 'package:notepro/routes/routes.dart'; 
import 'package:notepro/core/widgets/responsive_navbar.dart';
import 'package:notepro/core/widgets/landing_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Ajouté

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
      endDrawer: screenWidth <= 800
          ? Drawer(
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
                          ListTile(
                            title: const Text('Accueil'),
                            onTap: () => _navigate(context, 'home'),
                          ),
                          ListTile(
                            title: const Text('Avis'),
                            onTap: () => _navigate(context, 'reviews'),
                          ),
                          ListTile(
                            title: const Text('Catégories'),
                            onTap: () => _navigate(context, 'categories'),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Connexion'),
                            onTap: () => _navigate(context, Routes.login),
                          ),
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
            )
          : null,
      body: Column(
        children: [
          const ResponsiveNavbar(currentPage: 'home'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.login),
                    child: const Text('Se connecter'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, Routes.signup),
                    child: const Text('S\'inscrire'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Méthode helper pour la navigation
  void _navigate(BuildContext context, String routeName) {
    Navigator.pop(context);
    Navigator.pushNamed(context, routeName);
  }
}