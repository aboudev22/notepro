import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notepro/core/models/blog.dart';
import 'package:notepro/core/widgets/animation_card.dart';
import 'package:notepro/core/widgets/blog_post.dart';
import 'package:notepro/core/widgets/contact.dart';
import 'package:notepro/core/widgets/hero_section.dart';
import 'package:notepro/core/widgets/navbar.dart';
import 'package:notepro/core/widgets/burger_menu.dart';
import 'package:notepro/features/admin/presentation/recent_posts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _viewMenu = false;
  bool _isFocus = false;
  final FocusNode _searchFocusNode = FocusNode();

  void _handleMenuClick() {
    setState(() {
      _viewMenu = !_viewMenu;
    });
  }

  void _setFocus() {
    setState(() {
      _isFocus = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _removeFocus() {
    if (_isFocus) {
      setState(() {
        _isFocus = false;
      });
      _searchFocusNode.unfocus();
    }
  }

  void _closeMenuIfOpen() {
    if (_viewMenu) {
      setState(() {
        _viewMenu = false;
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _removeFocus();
        _closeMenuIfOpen();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/hero.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.black.withAlpha(51)),
                  ),
                ],
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Navbar(
                      onClick: _handleMenuClick,
                      focus: _isFocus,
                      handleFocus: _setFocus,
                      handleUnfocus: _removeFocus,
                      searchFocusNode: _searchFocusNode,
                    ),
                    const HeroSection(),
                    const SizedBox(height: 40),
                    const AnimationCard(),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width < 600 ? 5 : 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          children: [
                            ...List.generate(
                              blogPosts.length,
                              (index) => BlogPostCard(blog: blogPosts[index]),
                            ),
                            const RecentPosts(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Contacts(),
                  ],
                ),
              ),
            ),

            if (_viewMenu)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenuIfOpen,
                  child: Container(color: Colors.transparent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
