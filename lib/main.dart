//fichier d'entrer
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notepro/routes/routes.dart'; // Importer les routes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trust Review Blog',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: Routes.home, // Définir la route par défaut (Home Page)
      onGenerateRoute: Routes.generateRoute, // Générer les routes
    );
  }
}
