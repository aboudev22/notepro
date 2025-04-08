import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    color: const Color(0xff141414),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 100),
                          child: SelectableText(
                            'Rejoignez la communauté Note Pro - où chaque évaluation compte !',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                        Padding(
  padding: const EdgeInsets.only(left: 100, top: 10, bottom: 10),
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
            offset: const Offset(0, 5), // Décalage de 5 pixels vers le haut
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
                      color: Colors.white,
                      height: 50,
                    ),
                  ),
                ),
                Text(
                  'Partagez-la !',
                  style: TextStyle(
                    color: Colors.black,
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
                        const Padding(
                          padding: EdgeInsets.only(left: 100),
                          child: SelectableText(
                            'Rejoignez la communauté Note Pro - où chaque évaluation compte !',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
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
                    color: const Color(0xff141414),
                    child: const Column(
                      children: [
                        SelectableText('Bienvenue ici'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}