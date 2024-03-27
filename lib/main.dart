import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page_accueil_minuterie.dart';



const String CLE_TEMPS_TRAVAIL = 'Temps de travail';
const String CLE_PAUSE_COURTE = 'Pause courte';
const String CLE_PAUSE_LONGUE = 'Pause longue';

const int TEMPS_PAUSE_COURTE_DEFAUT = 5; // 5 minutes
const int TEMPS_PAUSE_LONGUE_DEFAUT = 20; // 20 minutes
const int TEMPS_TRAVAIL_DEFAUT = 30; // 30 minutes

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