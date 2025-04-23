import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Testnonials extends StatefulWidget {
  const Testnonials({super.key});

  @override
  State<Testnonials> createState() => _TestnonialsState();
}

class _TestnonialsState extends State<Testnonials> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 1024;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stack d'images
        Container(
          width: 256,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.grey[600]!, width: 2),
          ),
          child: Stack(
            children: [
              _buildUserImage('assets/user1.png', 0),
              _buildUserImage('assets/user2.png', 20),
              _buildUserImage('assets/user3.png', 40),
              _buildUserImage('assets/user4.png', 64),
            ],
          ),
        ),

        // Texte responsive
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            'Explorez 1000+ avis et notes',
            style: GoogleFonts.bricolageGrotesque(
              fontSize: isLargeScreen ? 36 : 24,
              color: isLargeScreen ? Colors.black : Colors.white,
            ),
          ),
        ),

        // Bouton avec effets hover
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isHovering ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Explorer',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 20,
                      color: _isHovering ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform:
                        Matrix4.identity()
                          ..translate(
                            _isHovering ? 8.0 : 0.0,
                            _isHovering ? -2.0 : 0.0,
                          )
                          ..scale(_isHovering ? 1.25 : 1.0),
                    child: Image.asset(
                      'assets/icons/row_up.png',
                      width: 20,
                      height: 20,
                      color: _isHovering ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserImage(String asset, double offset) {
    return Positioned(
      right: offset,
      child: Transform.translate(
        offset: Offset(-offset, 0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.grey[600]!, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(asset, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
