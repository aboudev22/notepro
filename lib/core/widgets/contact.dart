import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:notepro/features/pages/about_page.dart';
import 'package:notepro/features/pages/expertise_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.bricolageGrotesqueTextTheme()),
      home: const ContactsPage(),
    ),
  );
}

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(children: [SizedBox(height: 40), Contacts()]),
      ),
    );
  }
}

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return constraints.maxWidth >= 1024
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildLeftColumn(context, textStyle),
                          ),
                          Expanded(
                            flex: 3,
                            child: _buildRightGrid(context, textStyle),
                          ),
                        ],
                      )
                      : Column(
                        children: [
                          _buildLeftColumn(context, textStyle),
                          _buildRightGrid(context, textStyle),
                        ],
                      );
                },
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              const SizedBox(height: 20),
              _buildCopyright(textStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(BuildContext context, TextStyle baseStyle) {
    final gradientStyle = baseStyle.copyWith(
      fontSize: MediaQuery.of(context).size.width < 600 ? 24.0 : 38,
      fontWeight: FontWeight.bold,
      foreground:
          Paint()
            ..shader = LinearGradient(
              colors: [Colors.blue[600]!, Colors.red[700]!],
            ).createShader(const Rect.fromLTWH(0, 0, 300, 20)),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Venez noter votre produit !', style: gradientStyle),
          const SizedBox(height: 8.0),
          Text('Des classements chaque semaine.', style: gradientStyle),
        ],
      ),
    );
  }

  Widget _buildRightGrid(BuildContext context, TextStyle baseStyle) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: MediaQuery.of(context).size.width < 600 ? 3.5 : 10.0,
      children: [
        _GridTitle(text: 'Entreprise', style: baseStyle),
        _GridTitle(text: 'Services', style: baseStyle),
        _GridItem(
          text: 'À propos',
          style: baseStyle,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ),
        ),
        _GridItem(
          text: 'Expertise',
          style: baseStyle,
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ExpertisePage()),
              ),
        ),
        _GridItem(
          text: 'Notes',
          style: baseStyle,
          onTap: () {
            // TODO: Implémenter la navigation vers la page des notes
          },
        ),
        _GridItem(
          text: 'Support',
          style: baseStyle,
          onTap: () {
            // TODO: Implémenter la navigation vers la page de support
          },
        ),
        _GridItem(
          text: 'Blog',
          style: baseStyle,
          onTap: () => Navigator.pushNamed(context, '/blog'),
        ),
        _GridItem(
          text: 'Carrières',
          style: baseStyle,
          onTap: () {
            // TODO: Implémenter la navigation vers la page des carrières
          },
        ),
      ],
    );
  }

  Widget _buildCopyright(TextStyle baseStyle) {
    final year = DateTime.now().year;

    return Text(
      '© $year notepro. Tous droits réservés.',
      style: baseStyle.copyWith(color: Colors.white70, fontSize: 12.0),
    );
  }
}

class _GridTitle extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _GridTitle({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        text,
        style: style.copyWith(
          color: Colors.orange[400],
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class _GridItem extends StatefulWidget {
  final String text;
  final TextStyle style;
  final VoidCallback? onTap;

  const _GridItem({required this.text, required this.style, this.onTap});

  @override
  State<_GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<_GridItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            widget.text,
            style: widget.style.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              decoration: _isHovering ? TextDecoration.underline : null,
            ),
          ),
        ),
      ),
    );
  }
}
