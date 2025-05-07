import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:notepro/features/auth/presentation/providers/auth_provider.dart';
import 'package:notepro/features/admin/presentation/admin_dashboard.dart';

class BurgerMenu extends StatelessWidget {
  final bool visible;

  const BurgerMenu({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Overlay pour fermer le menu au clic
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          // Menu
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(204), // 0.8 * 255
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (!authProvider.isAuthenticated) ...[
                          _MenuItem(
                            text: 'Connexion',
                            onTap: () {
                              Navigator.pop(context); // Ferme le menu
                              Navigator.pushNamed(context, '/login');
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.black,
                            hoverBackgroundColor: Colors.black.withAlpha(153),
                            activeBackgroundColor: Colors.black.withAlpha(153),
                            borderRadius: BorderRadius.circular(6),
                            padding: const EdgeInsets.all(8),
                          ),
                          _MenuItem(
                            text: 'Inscription',
                            onTap: () {
                              Navigator.pop(context); // Ferme le menu
                              Navigator.pushNamed(context, '/signup');
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.black,
                            hoverBackgroundColor: Colors.black.withAlpha(153),
                            activeBackgroundColor: Colors.black.withAlpha(153),
                            borderRadius: BorderRadius.circular(6),
                            padding: const EdgeInsets.all(8),
                          ),
                        ] else ...[
                          if (authProvider.isAdmin)
                            _MenuItem(
                              text: 'Dashboard',
                              onTap: () {
                                Navigator.pop(context); // Ferme le menu
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardPage(),
                                  ),
                                );
                              },
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              backgroundColor: Colors.blue,
                              hoverBackgroundColor: Colors.blue.withAlpha(204),
                              activeBackgroundColor: Colors.blue.withAlpha(204),
                              borderRadius: BorderRadius.circular(6),
                              padding: const EdgeInsets.all(8),
                            ),
                          _MenuItem(
                            text: 'Déconnexion',
                            onTap: () async {
                              Navigator.pop(context); // Ferme le menu
                              await authProvider.signOut();
                            },
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            backgroundColor: Colors.red,
                            hoverBackgroundColor: Colors.red.withAlpha(204),
                            activeBackgroundColor: Colors.red.withAlpha(204),
                            borderRadius: BorderRadius.circular(6),
                            padding: const EdgeInsets.all(8),
                          ),
                        ],
                        _MenuItem(
                          text: 'Blog',
                          onTap: () {
                            Navigator.pop(context); // Ferme le menu
                            Navigator.pushNamed(context, '/blog');
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          hoverColor: Colors.white.withAlpha(153),
                          activeColor: Colors.white.withAlpha(153),
                        ),
                        _MenuItem(
                          text: 'Avis',
                          onTap: () {
                            Navigator.pop(context); // Ferme le menu
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          hoverColor: Colors.white.withAlpha(153),
                          activeColor: Colors.white.withAlpha(153),
                        ),
                        _MenuItem(
                          text: 'Notes',
                          onTap: () {
                            Navigator.pop(context); // Ferme le menu
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          hoverColor: Colors.white.withAlpha(153),
                          activeColor: Colors.white.withAlpha(153),
                        ),
                        _MenuItem(
                          text: 'Contacts',
                          onTap: () {
                            Navigator.pop(context); // Ferme le menu
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          hoverColor: Colors.white.withAlpha(153),
                          activeColor: Colors.white.withAlpha(153),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final Color? activeBackgroundColor;
  final Color? hoverColor;
  final Color? activeColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.text,
    required this.style,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.activeBackgroundColor,
    this.hoverColor,
    this.activeColor,
    this.borderRadius,
    this.padding,
    this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovering = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.style.color ?? Colors.white;

    if (_isActive && widget.activeColor != null) {
      textColor = widget.activeColor!;
    } else if (_isHovering && widget.hoverColor != null) {
      textColor = widget.hoverColor!;
    }

    Color backgroundColor = widget.backgroundColor ?? Colors.transparent;

    if (_isActive && widget.activeBackgroundColor != null) {
      backgroundColor = widget.activeBackgroundColor!;
    } else if (_isHovering && widget.hoverBackgroundColor != null) {
      backgroundColor = widget.hoverBackgroundColor!;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit:
          (_) => setState(() {
            _isHovering = false;
            _isActive = false;
          }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isActive = true),
        onTapUp: (_) => setState(() => _isActive = false),
        onTapCancel: () => setState(() => _isActive = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
