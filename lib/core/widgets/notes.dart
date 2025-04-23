import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with TickerProviderStateMixin {
  final List<String> images = [
    'assets/images/card1.png',
    'assets/images/card2.png',
    'assets/images/card3.png',
    'assets/images/card4.png',
    'assets/images/card5.png',
    'assets/images/card6.png',
  ];

  late Ticker _ticker;
  double _progress = 0;
  String _direction = "right";
  double _contentWidth = 0;
  double _imageHeight = 192;
  final double _speed = 60;
  final GlobalKey _contentKey = GlobalKey();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..stop();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSizes());
  }

  void _initSizes() {
    if (_isInitialized) return;

    final renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initSizes());
      return;
    }

    final screenSize = MediaQuery.of(context).size;

    _imageHeight = 192;
    if (screenSize.width >= 1024) {
      _imageHeight = 384;
    } else if (screenSize.width >= 768) {
      _imageHeight = 288;
    }

    final renderWidth = renderBox.size.width;
    _contentWidth = (renderWidth > 0 ? renderWidth : screenSize.width) / 2 - 30;
    if (_contentWidth.isNaN || _contentWidth <= 0) {
      _contentWidth = screenSize.width / 2 - 30;
    }

    _isInitialized = true;
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!_isInitialized || _contentWidth <= 0) return;

    final deltaTime = elapsed.inMilliseconds / 1000;
    final directionFactor = _direction == "right" ? -1 : 1;

    setState(() {
      _progress += _speed * deltaTime * directionFactor;
      _progress = _progress.clamp(-_contentWidth, 0.0);
      if (_progress <= -_contentWidth || _progress >= 0) {
        _direction = _direction == "right" ? "left" : "right";
      }
    });

    // reset ticker so elapsed is relative
    _ticker
      ..stop()
      ..start();
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
      margin: EdgeInsets.only(top: isLargeScreen ? 40.0 : 20.0),
      height: _imageHeight, // <-- spécifier la hauteur pour voir le carrousel
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: Offset(_progress, 0),
          child: Row(
            key: _contentKey,
            children: [..._buildImageSet(), ..._buildImageSet()],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildImageSet() {
    return images.map((image) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Image.asset(
          image,
          height: _imageHeight,
          width: _imageHeight,
          fit: BoxFit.cover,
          cacheWidth: _imageHeight.toInt(),
          errorBuilder:
              (context, error, stackTrace) => Container(
                height: _imageHeight,
                width: _imageHeight,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              ),
        ),
      );
    }).toList();
  }
}
