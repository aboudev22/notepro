import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notepro/core/models/blog.dart';
import 'package:notepro/core/widgets/animation_card.dart';
import 'package:notepro/core/widgets/blog_post.dart';
import 'package:notepro/core/widgets/contact.dart';
import 'package:notepro/core/widgets/hero_section.dart';
import 'package:notepro/core/widgets/navbar.dart';
import 'package:notepro/core/widgets/burger_menu.dart';
import 'package:notepro/features/companies/presentation/companies_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepro/routes/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _viewMenu = false;
  bool _isFocus = false;
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contactsKey = GlobalKey();

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

  void scrollToContacts() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _handleNavigation(String route) {
    _closeMenuIfOpen();
    Future.microtask(() {
      Navigator.pushNamed(context, route);
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    if (_viewMenu) {
      _closeMenuIfOpen();
    }
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
                controller: _scrollController,
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
                      onContactsTap: scrollToContacts,
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
                            StreamBuilder<QuerySnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('articles')
                                      .orderBy('createdAt', descending: true)
                                      .limit(5)
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Erreur: ${snapshot.error}'),
                                  );
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final articles = snapshot.data?.docs ?? [];

                                if (articles.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'Aucun article disponible',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children:
                                      articles.map((doc) {
                                        final data =
                                            doc.data() as Map<String, dynamic>;
                                        return BlogPostCard(
                                          id: doc.id,
                                          title: data['title'] ?? '',
                                          content: data['content'] ?? '',
                                          mainImage:
                                              data['mainImage'] != null
                                                  ? base64Decode(
                                                    data['mainImage'],
                                                  )
                                                  : null,
                                          createdAt:
                                              (data['createdAt'] as Timestamp)
                                                  .toDate(),
                                          likes: data['likes'] ?? 0,
                                          comments: data['comments'] ?? 0,
                                          shares: data['shares'] ?? 0,
                                          authorEmail:
                                              data['authorEmail'] ?? '',
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/article/${doc.id}',
                                            );
                                          },
                                        );
                                      }).toList(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Top 5 des Entreprises',
                                  style: GoogleFonts.bricolageGrotesque(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const CompaniesPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Voir plus',
                                    style: GoogleFonts.bricolageGrotesque(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'Entreprise',
                                            style:
                                                GoogleFonts.bricolageGrotesque(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Note',
                                            style:
                                                GoogleFonts.bricolageGrotesque(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Avis',
                                            style:
                                                GoogleFonts.bricolageGrotesque(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...List.generate(5, (index) {
                                    final companies = [
                                      {
                                        'name': 'MTN Cameroun',
                                        'rating': 4.8,
                                        'comments': 156,
                                      },
                                      {
                                        'name': 'Orange Cameroun',
                                        'rating': 4.5,
                                        'comments': 142,
                                      },
                                      {
                                        'name': 'Express Union',
                                        'rating': 4.2,
                                        'comments': 98,
                                      },
                                      {
                                        'name': 'Afriland First Bank',
                                        'rating': 4.7,
                                        'comments': 134,
                                      },
                                      {
                                        'name': 'UBA Cameroun',
                                        'rating': 4.3,
                                        'comments': 87,
                                      },
                                    ];
                                    final company = companies[index];
                                    return Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color:
                                            index % 2 == 0
                                                ? Colors.white.withOpacity(0.05)
                                                : Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.vertical(
                                          bottom:
                                              index == 4
                                                  ? const Radius.circular(12)
                                                  : Radius.zero,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              company['name'] as String,
                                              style:
                                                  GoogleFonts.bricolageGrotesque(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  company['rating'].toString(),
                                                  style:
                                                      GoogleFonts.bricolageGrotesque(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${company['comments']}',
                                              style:
                                                  GoogleFonts.bricolageGrotesque(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(key: _contactsKey, child: const Contacts()),
                  ],
                ),
              ),
            ),
            if (_viewMenu)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeMenuIfOpen,
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ),
            if (_viewMenu)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width * 0.7,
                child: BurgerMenu(
                  visible: _viewMenu,
                  onClose: _closeMenuIfOpen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
