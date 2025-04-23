import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (!_isPasswordValid(_passwordController.text)) {
      setState(
        () =>
            _errorMessage =
                'Le mot de passe doit contenir au moins 6 caractères.',
      );
      _isLoading = false;
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
            'createdAt': DateTime.now(),
          });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      setState(
        () => _errorMessage = e.message ?? 'Erreur lors de l\'inscription.',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,
              'email': userCredential.user!.email,
              'displayName': userCredential.user!.displayName,
              'createdAt': DateTime.now(),
            }, SetOptions(merge: true));

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erreur lors de la connexion Google.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final whiteColor = Colors.white;
    final white54 = Colors.white54;
    final grey900 = Colors.grey[900];

    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec image et effet de flou
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/auth.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          // Contenu principal
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', width: 64, height: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Yooo, Bienvenue ici!',
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Déjà un compte ? ',
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 12,
                          color: white54,
                        ),
                        children: [
                          TextSpan(
                            text: 'Connexion',
                            style: GoogleFonts.bricolageGrotesque(
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Formulaire
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          style: GoogleFonts.bricolageGrotesque(
                            color: whiteColor,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: grey900,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: white54),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: white54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor),
                            ),
                            hintText: 'Email',
                            hintStyle: GoogleFonts.bricolageGrotesque(
                              color: white54,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          style: GoogleFonts.bricolageGrotesque(
                            color: whiteColor,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: grey900,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(color: white54),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: white54),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor),
                            ),
                            hintText: 'Mot de passe',
                            hintStyle: GoogleFonts.bricolageGrotesque(
                              color: white54,
                            ),
                          ),
                          obscureText: true,
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'S\'inscrire',
                            style: GoogleFonts.bricolageGrotesque(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'ou',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 12,
                            color: white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          icon: Image.asset(
                            'assets/icons/google.png',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: _handleGoogleSignIn,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 12,
                          color: white54,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'En vous inscrivant, vous certifiez avoir lu et approuvé nos ',
                          ),
                          TextSpan(
                            text: 'Conditions Générales',
                            style: GoogleFonts.bricolageGrotesque(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' d\'Utilisation et notre '),
                          TextSpan(
                            text: 'Politique de Confidentialité',
                            style: GoogleFonts.bricolageGrotesque(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(
                            text: ', et vous acceptez de vous y conformer',
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
    );
  }
}
