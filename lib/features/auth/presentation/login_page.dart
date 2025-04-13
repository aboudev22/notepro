import 'package:flutter/material.dart';
import 'package:notepro/routes/routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Se connecter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Page de Connexion'),
            ElevatedButton(
              onPressed: () {
                // Navigation vers la page d'inscription
                Navigator.pushNamed(context, Routes.signup);
              },
              child: const Text('S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }
}
