import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Navbar extends StatefulWidget {
  final VoidCallback onClick;
  final bool focus;
  final VoidCallback handleFocus;
  final VoidCallback handleUnfocus;
  final FocusNode searchFocusNode;

  const Navbar({
    super.key,
    required this.onClick,
    this.focus = false,
    required this.handleFocus,
    required this.handleUnfocus,
    required this.searchFocusNode,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _isHoveredSign = false;
  bool _isHoveredSignup = false;
  bool _isRedigerHovered = false;
  bool _isEntrepriseHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.searchFocusNode.unfocus();
        widget.handleUnfocus();
      },
      child: Container(
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
                                  () => Navigator.pushNamed(context, '/Blog'),
                            ),
                            SizedBox(
                              width:
                                  MediaQuery.of(context).size.width < 1600
                                      ? 20
                                      : 32,
                            ),

                            _NavText(
                              text: 'Contacts',
                              onTap:
                                  () => Navigator.pushNamed(context, '/admin'),
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
            MediaQuery.of(context).size.width >= 1400
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHoveredSign = true),
                      onExit: (_) => setState(() => _isHoveredSign = false),
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
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
                                  _isHoveredSign ? Colors.white : Colors.blue,
                              fontSize: 20,
                              fontFamily:
                                  GoogleFonts.bricolageGrotesque().fontFamily,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isHoveredSignup = true),
                      onExit: (_) => setState(() => _isHoveredSignup = false),
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
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
                                  _isHoveredSignup ? Colors.white : Colors.blue,
                              fontSize: 20,
                              fontFamily:
                                  GoogleFonts.bricolageGrotesque().fontFamily,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isRedigerHovered = true),
                      onExit: (_) => setState(() => _isRedigerHovered = false),
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(6),
                        hoverColor: Colors.black.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _isRedigerHovered ? Colors.white : Colors.black,
                            border: Border.all(color: Colors.white, width: 2),
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
                    const SizedBox(width: 8),
                    MouseRegion(
                      onEnter:
                          (_) => setState(() => _isEntrepriseHovered = true),
                      onExit:
                          (_) => setState(() => _isEntrepriseHovered = false),
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap:
                            () => Navigator.pushNamed(context, '/Entreprise'),
                        borderRadius: BorderRadius.circular(2),
                        hoverColor: Colors.black,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _isEntrepriseHovered
                                    ? Colors.black
                                    : Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            'Entrepise',
                            style: TextStyle(
                              fontSize: 20,
                              color:
                                  _isEntrepriseHovered
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w600,
                              decoration:
                                  _isEntrepriseHovered
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : IconButton(
                  icon: Image.asset(
                    'assets/icons/more.png',
                    width: 48,
                    height: 48,
                  ),
                  onPressed: () {
                    widget.onClick();
                  },
                ),
          ],
        ),
      ),
    );
  }
}

class _NavText extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavText({required this.text, required this.onTap});

  @override
  State<_NavText> createState() => _NavTextState();
}

class _NavTextState extends State<_NavText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width < 1024 ? 16 : 20,
            fontFamily: GoogleFonts.bricolageGrotesque().fontFamily,
            fontWeight: FontWeight.w900,
            decoration:
                _isHovered ? TextDecoration.underline : TextDecoration.none,
            decorationThickness: _isHovered ? 1.5 : 0,
          ),
        ),
      ),
    );
  }
}
