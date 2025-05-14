import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:notepro/features/auth/data/services/auth_service.dart';
import 'package:notepro/features/auth/presentation/providers/auth_provider.dart';
import 'package:notepro/routes/routes.dart';
import 'firebase_options.dart';
import 'package:notepro/features/admin/presentation/create_article_page.dart';
import 'package:notepro/features/blog/presentation/blog_page.dart';
import 'package:notepro/features/blog/presentation/article_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    print('Initialisation de Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialisé avec succès');
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: $e');
    if (e.toString().contains('duplicate-app')) {
      print('L\'app Firebase est déjà initialisée');
    } else {
      rethrow;
    }
  }

  runApp(const MyApp());
}

class MyCustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NotePro',
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: WillPopScope(
              onWillPop: () async {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                  return false;
                }
                return true;
              },
              child: child!,
            ),
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.bricolageGrotesqueTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: Routes.home,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
