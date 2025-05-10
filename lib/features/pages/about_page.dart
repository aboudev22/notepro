import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'À propos',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notre Mission',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Notre plateforme est dédiée à l\'évaluation et à la notation des entreprises, des produits et des services. Nous croyons en la transparence et en la puissance des retours d\'expérience authentiques.',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Notre Histoire',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Fondée en 2024, notre plateforme est née d\'un besoin simple : aider les consommateurs à prendre des décisions éclairées grâce aux expériences partagées par la communauté. Nous avons créé un espace où les utilisateurs peuvent partager leurs avis, découvrir de nouvelles entreprises et contribuer à une économie plus transparente.',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Notre Engagement',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nous nous engageons à maintenir une plateforme fiable et transparente où chaque avis compte. Notre système de notation est conçu pour refléter fidèlement l\'expérience des utilisateurs, et nous travaillons constamment à améliorer nos outils pour offrir une expérience utilisateur optimale.',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
