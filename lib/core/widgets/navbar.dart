import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final VoidCallback onClick;
  final bool focus;
  final VoidCallback handleFocus;

  const Navbar({
    Key? key,
    required this.onClick,
    this.focus = false,
    required this.handleFocus,
  }) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Equivalent to stopPropagation
      child: Container(
        padding: const EdgeInsets.all(20.0), // p-5 (5 * 4 = 20px)
        child: Row(
          children: [
            Image.asset('assets/logo.png', width: 40, height: 40),
            if (!widget.focus) ...[
              const SizedBox(width: 16), // gap-4 (4 * 4 = 16px)
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hidden on small screens, flex on large
                    MediaQuery.of(context).size.width >= 1024
                        ? Row(
                          children: [
                            _NavText(
                              text: 'Blog',
                              onTap:
                                  () => Navigator.pushNamed(context, '/Blog'),
                            ),
                            const SizedBox(width: 32), // gap-8 (8 * 4 = 32px)
                            _NavText(
                              text: 'Avis',
                              onTap:
                                  () => Navigator.pushNamed(context, '/Avis'),
                            ),
                            const SizedBox(width: 32),
                            _NavText(
                              text: 'Notes',
                              onTap:
                                  () => Navigator.pushNamed(context, '/Notes'),
                            ),
                            const SizedBox(width: 32),
                            _NavText(text: 'Contacts', onTap: () {}),
                            const SizedBox(width: 32),
                            _NavText(text: 'Support', onTap: () {}),
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(6), // rounded-md
                ),
                padding: const EdgeInsets.all(8), // p-2
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/search.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText:
                              'Rechercher une entreprise, un produit, un service.',
                          border: InputBorder.none,
                        ),
                        onTap: widget.handleFocus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Right side buttons
            MediaQuery.of(context).size.width >= 1024
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text(
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationThickness: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // gap-2
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/signup'),
                        child: const Text(
                          'Inscription',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationThickness: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(6), // rounded-md
                        hoverColor: Colors.black.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.all(8), // p-2
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Redigez un avis',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap:
                            () => Navigator.pushNamed(context, '/Entreprise'),
                        borderRadius: BorderRadius.circular(2), // rounded-sm
                        hoverColor: Colors.black,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Entrepise',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600, // semibold
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
                  onPressed: widget.onClick,
                ),
          ],
        ),
      ),
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
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationThickness: 0, // Start with no underline
          ),
        ),
      ),
    );
  }
}
