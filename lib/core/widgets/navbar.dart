import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final VoidCallback? onMenuClick;

  const Navbar({Key? key, this.onMenuClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Logo + texte
          Row(
            children: [
              Image.asset('assets/logo.png', width: 48, height: 48),
              const SizedBox(width: 8),
              const Text(
                'notepro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF56E0F),
                ),
              ),
            ],
          ),

          if (isDesktop) ...[
            const Spacer(), // Pousse les éléments au centre
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavItemHover(label: 'Blog'),
                NavItemHover(label: 'Avis'),
                NavItemHover(label: 'Notes'),
                NavItemHover(label: 'Contacts'),
                NavItemHover(label: 'Support'),
              ],
            ),
            const Spacer(), // Pousse le bouton à droite
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF56E0F),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                elevation: 4,
              ),
              child: const Text(
                "S'inscrire",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ] else
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onMenuClick,
                  child: Image.asset(
                    'assets/icons/menu.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ✅ Widget NavItem avec effet de hover
class NavItemHover extends StatefulWidget {
  final String label;

  const NavItemHover({Key? key, required this.label}) : super(key: key);

  @override
  _NavItemHoverState createState() => _NavItemHoverState();
}

class _NavItemHoverState extends State<NavItemHover> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          widget.label,
          style: TextStyle(
            color: isHovering ? const Color(0xffF56E0F) : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
