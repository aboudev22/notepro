import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Partie supérieure (70%)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    color: const Color(0xff141414),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 100, top: 80, bottom: 20),
                          child: SelectableText(
                            'Rejoignez la communauté Note Pro - où chaque évaluation compte !',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100, top: 10, bottom: 100),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'BreeSerif',
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Votre Expérience est Unique, mais elle peut guider des milliers d\'autres - ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                WidgetSpan(
                                  child: Transform.translate(
                                    offset: const Offset(0, 5),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          left: -8,
                                          right: -10,
                                          top: 2,
                                          bottom: -5,
                                          child: Transform.rotate(
                                            angle: -0.1,
                                            child: Container(
                                              color: Color(0xFFF56E0F), // Orange
                                              height: 50,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Partagez-la !',
                                          style: TextStyle(
                                            color: const Color(0xff141414),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'BreeSerif',
                                            fontSize: 45,
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
                        const Divider(
                          height: 20,       // Espace vertical autour de la ligne
                          thickness: 0.5,     // Épaisseur de la ligne
                          color: Colors.grey, // Couleur
                          // indent: 20,       // Marge à gauche
                          // endIndent: 20,    // Marge à droite
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espacement égal
                          children: [
                            // Section 1
                            _buildStatSection("300", "+", "avis disponibles"),
                            Container(
                              height: 30, // Ajustez selon vos besoins
                              child: const VerticalDivider(
                                thickness: 1,
                                color: Colors.red,
                                width: 0.5,
                              ),
                            ),
                            // Section 2
                            _buildStatSection("12k", "+", "total downloads"),
                            Container(
                              height: 30, // Ajustez selon vos besoins
                              child: const VerticalDivider(
                                thickness: 1,
                                color: Colors.red,
                                width: 0.5,
                              ),
                            ),
                            // Section 3
                            _buildStatSection("10k", "+", "active viewer"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 0.5,
                  thickness: 1,
                  color: Color(0xff262626),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/bg_sun.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Explorez 1000+ d\'avis',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'BreeSerif',
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              SelectableText(
                                '1000+ avis redigés par la communauté notepro\nsur des produits et services',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'BreeSerif',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color(0xFF000000)),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.grey, width: 0.5),
                              )),
                              overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Explorez les avis',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'BreeSerif',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  'assets/icons/arrow_up.png',
                                  width: 16,
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0.5,
            thickness: 1,
            color: Color(0xff262626),
          ),
          // Partie inférieure (30%)
        Expanded(
          child: Container(
            color: const Color(0xff141414), //
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Section 1
                _buildBottomSection(
                  'assets/icons/icon1.png',
                  'Titre Section 1',
                  'Sous-titre explicatif',
                  'Texte complémentaire',
                  context,
                ),
                
                const VerticalDivider(
                  thickness: 0.5,
                  color: Color(0xff262626),
                  indent: 20,
                  endIndent: 20,
                ),
                
                // Section 2
                _buildBottomSection(
                  'assets/icons/icon1.png',
                  'Titre Section 2',
                  'Sous-titre explicatif',
                  'Texte complémentaire',
                  context,
                ),
                
                const VerticalDivider(
                  thickness: 0.5,
                  color: Color(0xff262626),
                  indent: 20,
                  endIndent: 20,
                ),
                
                // Section 3
                _buildBottomSection(
                  'assets/icons/icon1.png',
                  'Titre Section 3',
                  'Sous-titre explicatif',
                  'Texte complémentaire',
                  context,
                ),
              ],
            ),
          ),
      ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    String imagePath, 
    String title, 
    String subtitle, 
    String bottomText,
    BuildContext context,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/arrow_up.png',
                    width: 16,
                    height: 16,
                    color: Colors.grey,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              bottomText,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSection(String number, String symbol, String label) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: symbol,
                  style: const TextStyle(
                    color: Color(0xFFF56E0F), // Orange
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}