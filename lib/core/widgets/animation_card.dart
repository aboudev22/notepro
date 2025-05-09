import 'package:flutter/material.dart';
import 'dart:async';

class AnimationCard extends StatefulWidget {
  const AnimationCard({super.key});

  @override
  State<AnimationCard> createState() => _AnimationCardState();
}

class _AnimationCardState extends State<AnimationCard>
    with SingleTickerProviderStateMixin {
  // late final AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  final List<String> _images = [
    'assets/images/card1.png',
    'assets/images/card2.png',
    'assets/images/card3.png',
    'assets/images/card4.png',
    'assets/images/card5.png',
    'assets/images/card6.png',
  ];

  Timer? _scrollTimer;

  double _responsiveImageWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 250; // Mobile
    if (width < 1200) return 380; // Tablette
    return 400; // PC / Grand écran
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 5), (_) {
      if (_scrollController.hasClients &&
          _scrollController.position.hasContentDimensions) {
        double maxExtent = _scrollController.position.maxScrollExtent;
        double current = _scrollController.offset + 0.5;

        if (current >= maxExtent) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(current);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageWidth = _responsiveImageWidth(context);

    return SizedBox(
      height: imageWidth * 1,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final imagePath = _images[index % _images.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _HoverImage(
              imagePath: imagePath,
              width: imageWidth,
              height: imageWidth * 0.7,
            ),
          );
        },
        itemCount: 1000,
      ),
    );
  }
}

class _HoverImage extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;

  const _HoverImage({
    required this.imagePath,
    required this.width,
    required this.height,
  });

  @override
  State<_HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<_HoverImage> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.imagePath,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
