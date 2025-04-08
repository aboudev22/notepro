import 'package:flutter/material.dart';
import 'package:notepro/routes/routes.dart'; 

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Page de Connexion'),
            ElevatedButton(
                    onPressed: () {
                      // Navigation vers la page d'inscription
                      Navigator.pushNamed(context, Routes.signup);
                    },
                    child: Text('S\'inscrire'),
                  ),
          ],
        ),
      ),
    );
  }
}
