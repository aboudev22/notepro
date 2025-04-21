import 'package:flutter/material.dart';
import 'package:notepro/core/widgets/burger_menu.dart';
import 'package:notepro/core/widgets/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showMenu = false;

  void toggleMenu() {
    setState(() {
      showMenu = !showMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleMenu,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        body: Stack(
          children: [
            // Contenu principal
            SingleChildScrollView(
              child: Column(
                children: [
                  Navbar(onMenuClick: toggleMenu),
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue sur NotePro',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Votre plateforme de prise de notes.',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Burger menu
            BurgerMenu(visible: showMenu),
          ],
        ),
      ),
    );
  }
}
