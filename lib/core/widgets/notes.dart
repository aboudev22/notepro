import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  final List<String> images = [
    'assets/card1.png',
    'assets/card2.png',
    'assets/card3.png',
    'assets/card4.png',
    'assets/card5.png',
    'assets/card6.png',
  ];

  late Ticker _ticker;
  double _progress = 0;
  String _direction = "right";
  double _contentWidth = 0;
  double _imageHeight = 192;
  double _speed = 60;
  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSizes());
  }

  void _initSizes() {
    final renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final screenSize = MediaQuery.of(context).size;

    // Gestion des breakpoints
    if (screenSize.width >= 1024) {
      _imageHeight = 384; // lg:h-96 (96 * 4)
    } else if (screenSize.width >= 768) {
      _imageHeight = 288;
    }

    _contentWidth = (renderBox.size.width / 2) - 30; // Ajustement pour gap-10
    _ticker.start();
  }

  void _onTick(Duration elapsed) {
    final deltaTime = elapsed.inMilliseconds / 1000;
    final directionFactor = _direction == "right" ? -1 : 1;

    setState(() {
      _progress += _speed * deltaTime * directionFactor;
      _progress = _progress.clamp(-_contentWidth, 0.0);

      if (_progress <= -_contentWidth || _progress >= 0) {
        _direction = _direction == "right" ? "left" : "right";
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width >= 1024;

    return Container(
      margin: EdgeInsets.only(
        top: isLargeScreen ? 40.0 : 20.0, // Gestion du margin-top
      ),
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(_progress, 0),
          child: Row(
            key: _contentKey,
            children: [
              ..._buildImageSet(),
              ..._buildImageSet(), // Duplication pour l'effet infini
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildImageSet() {
    return images.map((image) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // gap-10
        child: Image.asset(
          image,
          height: _imageHeight,
          width: _imageHeight, // Ratio 1:1
          fit: BoxFit.cover,
          cacheWidth: _imageHeight.toInt(), // Optimisation GPU
        ),
      );
    }).toList();
  }
}
