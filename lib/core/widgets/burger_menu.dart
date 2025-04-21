import 'package:flutter/material.dart';

class BurgerMenu extends StatelessWidget {
  final bool visible;

  const BurgerMenu({Key? key, required this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 240,
        color: Colors.black.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _MenuItem(label: 'Blog'),
            _MenuItem(label: 'Avis'),
            _MenuItem(label: 'Notes'),
            _MenuItem(label: 'Contacts'),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;

  const _MenuItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
