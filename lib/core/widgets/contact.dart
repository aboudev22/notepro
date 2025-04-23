import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
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
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.only(bottom: 40.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth >= 1024
                  ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: _buildLeftColumn(textStyle),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: _buildRightGrid(textStyle),
                      ),
                    ],
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLeftColumn(textStyle),
                      _buildRightGrid(textStyle),
                    ],
                  );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeftColumn(TextStyle baseStyle) {
    final gradientStyle = baseStyle.copyWith(
      fontSize: 24.0,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Venez notez votre produit!', style: gradientStyle),
          const SizedBox(height: 8.0),
          Text('Des classement chaque semaine.', style: gradientStyle),
        ],
      ),
    );
  }

  Widget _buildRightGrid(TextStyle baseStyle) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: [
        _GridTitle(text: 'Entreprise', style: baseStyle),
        _GridTitle(text: 'Services', style: baseStyle),
        _GridItem(text: 'A propos', style: baseStyle),
        _GridItem(text: 'Expertise', style: baseStyle),
        _GridItem(text: 'Notes', style: baseStyle),
        _GridItem(text: 'A propos', style: baseStyle),
        _GridItem(text: 'Expertise', style: baseStyle),
        _GridItem(text: 'Notes', style: baseStyle),
        _GridItem(text: 'Expertise', style: baseStyle),
        _GridItem(text: 'Notes', style: baseStyle),
      ],
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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: style.copyWith(
          color: Colors.orange[400],
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
    );
  }
}

class _GridItem extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _GridItem({required this.text, required this.style});

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
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.text,
            style: widget.style.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12.0,
              decoration: _isHovering ? TextDecoration.underline : null,
            ),
          ),
        ),
      ),
    );
  }
}
