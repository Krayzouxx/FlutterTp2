import 'package:flutter/material.dart';
import 'page_accueil_minuterie.dart';
import 'variables_globales.dart' as globals;



void main() {
  globals.temps_travail = 30;
  globals.temps_mini = 5;
  globals.temps_maxi = 20;
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