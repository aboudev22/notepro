import 'package:flutter/material.dart';
import 'dart:ui';

class BurgerMenu extends StatelessWidget {
  final bool visible;

  const BurgerMenu({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6, // h-3/5
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8), // bg-black/80
          // Flutter's backdrop filter for blur effect
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2.0,
            sigmaY: 2.0,
          ), // backdrop-blur-xs
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround, // justify-around
            children: [
              _MenuItem(
                text: 'Connexion',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20, // text-xl
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: Colors.black,
                hoverBackgroundColor: Colors.black.withOpacity(0.6),
                activeBackgroundColor: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(6), // rounded-md
                padding: const EdgeInsets.all(8), // p-2
              ),
              _MenuItem(
                text: 'Blog',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                hoverColor: Colors.white.withOpacity(0.6),
                activeColor: Colors.white.withOpacity(0.6),
              ),
              _MenuItem(
                text: 'Avis',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                hoverColor: Colors.white.withOpacity(0.6),
                activeColor: Colors.white.withOpacity(0.6),
              ),
              _MenuItem(
                text: 'Notes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                hoverColor: Colors.white.withOpacity(0.6),
                activeColor: Colors.white.withOpacity(0.6),
              ),
              _MenuItem(
                text: 'Contacts',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                hoverColor: Colors.white.withOpacity(0.6),
                activeColor: Colors.white.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final Color? activeBackgroundColor;
  final Color? hoverColor;
  final Color? activeColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const _MenuItem({
    required this.text,
    required this.style,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.activeBackgroundColor,
    this.hoverColor,
    this.activeColor,
    this.borderRadius,
    this.padding,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _isHovering = false;
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.style.color ?? Colors.white;

    if (_isActive && widget.activeColor != null) {
      textColor = widget.activeColor!;
    } else if (_isHovering && widget.hoverColor != null) {
      textColor = widget.hoverColor!;
    }

    Color backgroundColor = widget.backgroundColor ?? Colors.transparent;

    if (_isActive && widget.activeBackgroundColor != null) {
      backgroundColor = widget.activeBackgroundColor!;
    } else if (_isHovering && widget.hoverBackgroundColor != null) {
      backgroundColor = widget.hoverBackgroundColor!;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit:
          (_) => setState(() {
            _isHovering = false;
            _isActive = false;
          }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isActive = true),
        onTapUp: (_) => setState(() => _isActive = false),
        onTapCancel: () => setState(() => _isActive = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          child: Text(
            widget.text,
            style: widget.style.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
