import 'package:flutter/material.dart';
import 'package:notepro/features/admin/presentation/admin_dashboard.dart';
import 'package:notepro/features/admin/presentation/create_article_page.dart';
import 'package:notepro/features/auth/presentation/home_page.dart'; // Importe la page Home
import 'package:notepro/features/auth/presentation/login_page.dart'; // Page de connexion
import 'package:notepro/features/auth/presentation/signup_page.dart'; // Page d'inscription
import 'package:notepro/features/blog/presentation/blog_page.dart';
import 'package:notepro/features/blog/presentation/article_page.dart';
import 'package:notepro/features/pages/about_page.dart';
import 'package:notepro/features/pages/expertise_page.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String adminDashboard =
      '/admin'; // Ajoute le chemin pour le tableau de bord admin
  static const String writeBlogPage =
      '/writeblog'; // Ajoute le chemin pour écrire un blog
  static const String createArticle = '/create-article';
  static const String blog = '/blog';
  static const String article = '/article';
  static const String about = '/about';
  static const String expertise = '/expertise';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _buildRoute(const HomePage());
      case login:
        return _buildRoute(const LoginPage());
      case adminDashboard:
        return _buildRoute(const DashboardPage());
      case signup:
        return _buildRoute(const SignupPage());
      case createArticle:
        return _buildRoute(const CreateArticlePage());
      case blog:
        return _buildRoute(const BlogPage());
      case article:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(ArticlePage(articleId: args['id']));
      case about:
        return _buildRoute(const AboutPage());
      case expertise:
        return _buildRoute(const ExpertisePage());
      default:
        return _buildRoute(
          const Scaffold(body: Center(child: Text('Page non trouvée'))),
        );
    }
  }

  static PageRoute _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
