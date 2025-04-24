import 'package:flutter/material.dart';
import 'package:notepro/features/admin/widgets/reordable_wrap.dart';

class ResponsiveReorderableWrap extends StatelessWidget {
  const ResponsiveReorderableWrap({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: isDesktop ? 220 : 750, // Hauteur limitée sur desktop
        child: const ReorderableWrap(),
      ),
    );
  }
}
