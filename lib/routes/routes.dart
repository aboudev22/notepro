import 'package:flutter/material.dart';
import 'package:notepro/features/admin/presentation/admin_dashboard.dart';
import 'package:notepro/features/auth/presentation/home_page.dart'; // Importe la page Home
import 'package:notepro/features/auth/presentation/login_page.dart'; // Page de connexion
import 'package:notepro/features/auth/presentation/signup_page.dart'; // Page d'inscription

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String adminDashboard =
      '/admin'; // Ajoute le chemin pour le tableau de bord admin
  static const String writeBlogPage =
      '/writeblog'; // Ajoute le chemin pour écrire un blog

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('Page non trouvée'))),
        );
    }
  }
}
