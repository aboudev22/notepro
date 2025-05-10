import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpertisePage extends StatelessWidget {
  const ExpertisePage({super.key});

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
                        'Expertise',
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
                          'Notre Expertise',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Notre plateforme s\'appuie sur une expertise approfondie dans l\'analyse et l\'évaluation des entreprises et des services. Nous utilisons des méthodologies rigoureuses pour garantir des évaluations précises et pertinentes.',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildExpertiseSection(
                          'Analyse de Données',
                          'Notre système d\'analyse de données avancé permet de traiter et d\'interpréter les retours d\'expérience des utilisateurs, offrant ainsi une vision claire et objective des performances des entreprises.',
                        ),
                        const SizedBox(height: 32),
                        _buildExpertiseSection(
                          'Évaluation Multicritères',
                          'Nous évaluons les entreprises sur plusieurs critères essentiels : qualité du service, rapport qualité-prix, innovation, satisfaction client et durabilité.',
                        ),
                        const SizedBox(height: 32),
                        _buildExpertiseSection(
                          'Transparence et Fiabilité',
                          'Notre processus d\'évaluation est transparent et vérifiable. Chaque notation est basée sur des données réelles et des retours d\'expérience authentiques.',
                        ),
                        const SizedBox(height: 32),
                        _buildExpertiseSection(
                          'Innovation Continue',
                          'Nous développons constamment de nouveaux outils et méthodologies pour améliorer la précision et la pertinence de nos évaluations.',
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

  Widget _buildExpertiseSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
