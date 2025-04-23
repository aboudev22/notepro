import 'package:flutter/material.dart';

class SendMail extends StatelessWidget {
  const SendMail({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 1024;

    return Container(
      constraints: BoxConstraints(
        minHeight:
            MediaQuery.of(context).size.height * 0.95, // Augmenté de 0.8 à 0.95
        maxHeight:
            MediaQuery.of(context).size.height, // Augmenté à 100% de la hauteur
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20), // py-5
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Section
                Flexible(
                  child: Padding(
                    padding:
                        isLargeScreen
                            ? const EdgeInsets.only(right: 20) // pr-5
                            : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nous sommes toujours aussi fiere de vous lire et repondre a vos questions',
                          style: TextStyle(
                            fontFamily: 'RicolageGrotesque',
                            fontSize:
                                isLargeScreen ? 32 : 20, // text-xl/lg:text-4xl
                            fontWeight: FontWeight.w300, // font-light
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          children: [
                            _GridItem(
                              text: 'Email',
                              isTitle: true,
                              fontSize: isLargeScreen ? 24 : 20,
                            ),
                            _GridItem(
                              text: 'Nos reseaux',
                              isTitle: true,
                              fontSize: isLargeScreen ? 24 : 20,
                            ),
                            const _HoverableText(text: 'notepro@contact.cm'),
                            const _HoverableText(text: 'Facebook'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Section
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: isLargeScreen ? 0 : 20,
                      left: isLargeScreen ? 20 : 0,
                    ),
                    padding: const EdgeInsets.all(32), // p-8
                    constraints: BoxConstraints(
                      minHeight:
                          isLargeScreen
                              ? 500
                              : 400, // Ajout d'une hauteur minimale
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1), // bg-black/10
                      borderRadius: BorderRadius.circular(32), // rounded-4xl
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Ajout pour permettre l'expansion
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nous contacter',
                          style: TextStyle(
                            fontFamily: 'RicolageGrotesque',
                            fontSize: isLargeScreen ? 28 : 24, // lg:text-3xl
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Dite nous ce a quoi vous pensez, et notre equipe vous repond dans les minutes qui suivents',
                          style: TextStyle(
                            fontFamily: 'RicolageGrotesque',
                            fontSize: isLargeScreen ? 20 : 16, // lg:text-xl
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const _FormInput(hint: 'Nom'),
                        const _FormInput(hint: 'Email', isEmail: true),
                        const _FormInput(hint: 'Objet'),
                        const Expanded(
                          child: SizedBox(
                            child: _FormInput(hint: 'Message', maxLines: 4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                100,
                              ), // rounded-full
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24, // px-3
                              vertical: 8, // p-2
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Envoyer',
                            style: TextStyle(
                              fontFamily: 'RicolageGrotesque',
                              color: Colors.white,
                              fontWeight: FontWeight.w600, // font-semibold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FormInput extends StatelessWidget {
  final String hint;
  final bool isEmail;
  final int maxLines;

  const _FormInput({
    required this.hint,
    this.isEmail = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54), // border-black/50
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8), // py-2
      ),
    );
  }
}

class _HoverableText extends StatefulWidget {
  final String text;

  const _HoverableText({required this.text});

  @override
  State<_HoverableText> createState() => _HoverableTextState();
}

class _HoverableTextState extends State<_HoverableText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        child: Text(
          widget.text,
          style: TextStyle(
            fontFamily: 'RicolageGrotesque',
            decoration: _isHovering ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String text;
  final bool isTitle;
  final double fontSize;

  const _GridItem({
    required this.text,
    this.isTitle = false,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'RicolageGrotesque',
          fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
