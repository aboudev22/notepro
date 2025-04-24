import 'package:flutter/material.dart';

class AdminAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onRefresh;
  final VoidCallback onCreateArticle;

  const AdminAppBar({
    super.key,
    required this.onRefresh,
    required this.onCreateArticle,
  });

  @override
  State<AdminAppBar> createState() => _AdminAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AdminAppBarState extends State<AdminAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  bool isHoveringRefresh = false;
  bool isHoveringArticle = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  void _startRotation() {
    _rotationController.repeat();
    Future.delayed(const Duration(milliseconds: 700), () {
      _rotationController.stop();
      _rotationController.reset();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "Tableau de bord. Bienvenue, Admin",
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                isHoveringRefresh = true;
              });
              _startRotation();
            },
            onExit: (_) {
              setState(() {
                isHoveringRefresh = false;
              });
            },
            child: TextButton.icon(
              onPressed: () {
                _startRotation();
                widget.onRefresh();
              },
              icon: RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
                child: const Icon(Icons.refresh, color: Colors.black),
              ),
              label: const Text(
                "Refresh All",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: MouseRegion(
            onEnter: (_) => setState(() => isHoveringArticle = true),
            onExit: (_) => setState(() => isHoveringArticle = false),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
                boxShadow:
                    isHoveringArticle
                        ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(
                              0,
                              -2,
                            ), // changes position of shadow
                          ),
                        ]
                        : null,
              ),
              child: TextButton.icon(
                onPressed: widget.onCreateArticle,
                icon: Icon(
                  Icons.add,
                  color: isHoveringArticle ? Colors.black : Colors.white,
                ),
                label: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Text(
                    "Nouvel article",
                    style: TextStyle(
                      color: isHoveringArticle ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
