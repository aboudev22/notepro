import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:notepro/features/auth/presentation/providers/auth_provider.dart';
import 'package:notepro/routes/routes.dart';
import 'package:notepro/features/admin/presentation/admin_dashboard.dart';
import 'package:notepro/core/widgets/burger_menu.dart';

class Navbar extends StatefulWidget {
  final VoidCallback onClick;
  final bool focus;
  final VoidCallback handleFocus;
  final VoidCallback handleUnfocus;
  final FocusNode searchFocusNode;
  final VoidCallback onContactsTap;

  const Navbar({
    super.key,
    required this.onClick,
    required this.focus,
    required this.handleFocus,
    required this.handleUnfocus,
    required this.searchFocusNode,
    required this.onContactsTap,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _isHoveredSign = false;
  bool _isHoveredSignup = false;
  bool _isRedigerHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image.asset('assets/logo.png', width: 50, height: 50),
              if (!widget.focus) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaQuery.of(context).size.width >= 1024
                          ? Row(
                            children: [
                              _NavText(
                                text: 'Blog',
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      Routes.blog,
                                    ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width < 1600
                                        ? 20
                                        : 32,
                              ),
                              _NavText(
                                text: 'Contacts',
                                onTap: widget.onContactsTap,
                              ),
                            ],
                          )
                          : Container(),
                    ],
                  ),
                ),
              ],
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width:
                      widget.focus
                          ? MediaQuery.of(context).size.width * 0.5
                          : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.2 * 255).toInt()),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/search.png',
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            focusNode: widget.searchFocusNode,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              hintText:
                                  'Rechercher une entreprise, un produit, un service.',
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              widget.handleFocus();
                            },
                            onSubmitted: (value) {
                              widget.handleUnfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (!isMobile) ...[
                MediaQuery.of(context).size.width >= 1400
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (authProvider.isAuthenticated) ...[
                          if (authProvider.isAdmin)
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const DashboardPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: const Icon(
                                    Icons.dashboard,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => authProvider.signOut(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Text(
                                  'Déconnexion',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily:
                                        GoogleFonts.bricolageGrotesque()
                                            .fontFamily,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          MouseRegion(
                            onEnter:
                                (_) => setState(() => _isHoveredSign = true),
                            onExit:
                                (_) => setState(() => _isHoveredSign = false),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    Routes.login,
                                  ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _isHoveredSign ? Colors.blue : null,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Text(
                                  'Connexion',
                                  style: TextStyle(
                                    color:
                                        _isHoveredSign
                                            ? Colors.white
                                            : Colors.blue,
                                    fontSize: 20,
                                    fontFamily:
                                        GoogleFonts.bricolageGrotesque()
                                            .fontFamily,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          MouseRegion(
                            onEnter:
                                (_) => setState(() => _isHoveredSignup = true),
                            onExit:
                                (_) => setState(() => _isHoveredSignup = false),
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap:
                                  () => Navigator.pushNamed(
                                    context,
                                    Routes.signup,
                                  ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _isHoveredSignup ? Colors.blue : null,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Text(
                                  'Inscription',
                                  style: TextStyle(
                                    color:
                                        _isHoveredSignup
                                            ? Colors.white
                                            : Colors.blue,
                                    fontSize: 20,
                                    fontFamily:
                                        GoogleFonts.bricolageGrotesque()
                                            .fontFamily,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        MouseRegion(
                          onEnter:
                              (_) => setState(() => _isRedigerHovered = true),
                          onExit:
                              (_) => setState(() => _isRedigerHovered = false),
                          cursor: SystemMouseCursors.click,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(6),
                            hoverColor: Colors.black.withOpacity(0.1),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color:
                                    _isRedigerHovered
                                        ? Colors.white
                                        : Colors.black,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Text(
                                'Redigez un avis',
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      _isRedigerHovered
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration:
                                      _isRedigerHovered
                                          ? TextDecoration.underline
                                          : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: widget.onClick,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _NavText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _NavText({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
