import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives des entreprises
    final companies = [
      {'name': 'MTN Cameroun', 'rating': 4.8, 'comments': 156},
      {'name': 'Orange Cameroun', 'rating': 4.5, 'comments': 142},
      {'name': 'Express Union', 'rating': 4.2, 'comments': 98},
      {'name': 'Afriland First Bank', 'rating': 4.7, 'comments': 134},
      {'name': 'UBA Cameroun', 'rating': 4.3, 'comments': 87},
      {'name': 'Ecobank Cameroun', 'rating': 4.4, 'comments': 92},
      {'name': 'Canal+ Cameroun', 'rating': 4.1, 'comments': 76},
      {'name': 'Camtel', 'rating': 3.8, 'comments': 112},
      {'name': 'Nexttel', 'rating': 3.9, 'comments': 89},
      {'name': 'Camair-Co', 'rating': 3.7, 'comments': 67},
      {'name': 'Douala Port Authority', 'rating': 4.0, 'comments': 78},
      {'name': 'ENEO', 'rating': 3.5, 'comments': 145},
      {'name': 'CDE', 'rating': 3.6, 'comments': 82},
      {'name': 'SODECOTON', 'rating': 4.2, 'comments': 56},
      {'name': 'CAMTEL', 'rating': 3.8, 'comments': 94},
      {'name': 'CAMRAIL', 'rating': 3.9, 'comments': 88},
      {'name': 'CAMTEL Mobile', 'rating': 3.7, 'comments': 72},
      {'name': 'CAMTEL Internet', 'rating': 3.6, 'comments': 68},
      {'name': 'CAMTEL Fixed', 'rating': 3.8, 'comments': 75},
      {'name': 'CAMTEL Corporate', 'rating': 4.0, 'comments': 82},
    ];

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
                        'Top 20 des Entreprises',
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
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Entreprise',
                                  style: GoogleFonts.bricolageGrotesque(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Note',
                                  style: GoogleFonts.bricolageGrotesque(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Avis',
                                  style: GoogleFonts.bricolageGrotesque(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...companies.asMap().entries.map((entry) {
                          final index = entry.key;
                          final company = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  index % 2 == 0
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    company['name'] as String,
                                    style: GoogleFonts.bricolageGrotesque(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        company['rating'].toString(),
                                        style: GoogleFonts.bricolageGrotesque(
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
                                    style: GoogleFonts.bricolageGrotesque(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
