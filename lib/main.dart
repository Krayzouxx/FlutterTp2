import 'package:flutter/material.dart';
import 'page_accueil_minuterie.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final minuteur = Minuteur();

  void majParametres() {
    minuteur.lireParametres();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penaldo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black45),
          bodyMedium: TextStyle(color: Colors.black45),
        ),
      ),
      home: PageAccueilMinuterie(onParametresChanged: majParametres),
    );
  }
}