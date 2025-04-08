import 'package:flutter/material.dart';
import 'package:notepro/features/auth/presentation/home_page.dart'; // Importe la page Home
import 'package:notepro/features/auth/presentation/login_page.dart'; // Page de connexion
import 'package:notepro/features/auth/presentation/signup_page.dart'; // Page d'inscription

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage()); // Assure-toi de créer LoginPage
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage()); // Assure-toi de créer SignupPage
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page non trouvée')),
          ),
        );
    }
  }
}
