import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepro/routes/routes.dart';
import 'dart:math' as math;

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet = MediaQuery.of(context).size.width < 1000;
    final isLargeScreen = MediaQuery.of(context).size.width >= 1600;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Grand texte principal
          SelectableText.rich(
            TextSpan(
              style: GoogleFonts.bricolageGrotesque(
                fontSize:
                    isLargeScreen ? 80 : (isMobile ? 32 : (isTablet ? 28 : 48)),
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.3,
              ),
              children: [
                const TextSpan(text: "Des "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: -math.pi / 18,
                        child: Container(
                          width: isMobile ? 150 : 300,
                          height: isMobile ? 20 : (isTablet ? 35 : 40),
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "milliers",
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize:
                              isLargeScreen
                                  ? 80
                                  : (isMobile ? 32 : (isTablet ? 28 : 48)),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const TextSpan(text: " d'avis et reviews sur des "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "entreprises",
                              style: GoogleFonts.bricolageGrotesque(
                                fontWeight: FontWeight.w900,
                                fontSize:
                                    isLargeScreen
                                        ? 80
                                        : (isMobile
                                            ? 32
                                            : (isTablet ? 28 : 48)),
                                color: Colors.white,
                              ),
                            ),
                            if (!isMobile)
                              Image.asset(
                                'assets/circle.png',
                                width: isMobile ? 260 : (isTablet ? 440 : 540),
                                height: isMobile ? 90 : (isTablet ? 105 : 160),
                                fit: BoxFit.fill,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const TextSpan(text: " et vos "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: -math.pi / 25,
                        child: Container(
                          width: isMobile ? 165 : 350,
                          height: isMobile ? 20 : (isTablet ? 30 : 40),
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "produits",
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w500,
                          fontSize:
                              isLargeScreen
                                  ? 80
                                  : (isMobile ? 32 : (isTablet ? 28 : 48)),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const TextSpan(text: " du quotidien"),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Images testimonials
          Center(
            child: SizedBox(
              width: 250,
              height: 100,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    child: _testimonialImage("assets/user1.png"),
                  ),
                  Positioned(
                    left: 50,
                    child: _testimonialImage("assets/user2.png"),
                  ),
                  Positioned(
                    left: 100,
                    child: _testimonialImage("assets/user3.png"),
                  ),
                  Positioned(
                    left: 150,
                    child: _testimonialImage("assets/user4.png"),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Texte avis
          Text(
            "Explorez 1000+ avis et notes",
            style: GoogleFonts.bricolageGrotesque(
              fontSize: isLargeScreen ? 32 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 24),

          // Bouton Explorer
          MouseRegion(
            onEnter: (_) {},
            onExit: (_) {},
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.blog),
              child: _ExploreButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _testimonialImage(String path) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.grey,
        image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
      ),
    );
  }
}

class _ExploreButton extends StatefulWidget {
  @override
  State<_ExploreButton> createState() => _ExploreButtonState();
}

class _ExploreButtonState extends State<_ExploreButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 1600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _hover ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 32 : 20,
            vertical: isLargeScreen ? 16 : 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Explorer",
                style: GoogleFonts.bricolageGrotesque(
                  color: _hover ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isLargeScreen ? 32 : 16,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                offset: _hover ? const Offset(0, -0.2) : Offset.zero,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  Icons.arrow_upward,
                  color: _hover ? Colors.black : Colors.white,
                  size: isLargeScreen ? 32 : 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
