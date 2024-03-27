import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'page_parametres.dart';

class ModeleMinuteur {
  String? temps;
  double? pourcentage;

  ModeleMinuteur(this.temps, this.pourcentage);
}

class Minuteur {
  double _pourcentage = 1.0;
  bool _estActif = false;
  Duration _temps = const Duration(minutes: 30);
  Duration _tempsTotal = const Duration(minutes: 30);
  Duration tempsPauseCourte = const Duration(minutes: 5);
  Duration tempsPauseLongue = const Duration(minutes: 20);

  String retournerTemps(Duration t) {
    String minutes = t.inMinutes.toString().padLeft(2, '0');
    int numSecondes = t.inSeconds - (t.inMinutes * 60);
    String secondes = numSecondes.toString().padLeft(2, '0');
    String tempsFormate = '$minutes:$secondes';
    return tempsFormate;
  }

  Stream<ModeleMinuteur> stream() async* {
    yield* Stream.periodic(const Duration(seconds: 1), (int a) {
      if (_estActif) {
        _temps = _temps - const Duration(seconds: 1);
      }
      if (_temps.inSeconds <= 0) {
        _estActif = false;
        _temps = const Duration();
      }
      if (_tempsTotal.inSeconds != 0) {
        _pourcentage = _temps.inSeconds / _tempsTotal.inSeconds;
      } else {
        _pourcentage = 1.0;
      }
      return ModeleMinuteur(retournerTemps(_temps), _pourcentage);
    });
  }

  Future<void> lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? tempsPauseCourteMinutes = preferences.getInt(CLE_PAUSE_COURTE);
    if (tempsPauseCourteMinutes == null) {
      await preferences.setInt(CLE_PAUSE_COURTE, TEMPS_PAUSE_COURTE_DEFAUT);
    }
    int? tempsPauseLongueMinutes = preferences.getInt(CLE_PAUSE_LONGUE);
    if (tempsPauseLongueMinutes == null) {
      await preferences.setInt(CLE_PAUSE_LONGUE, TEMPS_PAUSE_LONGUE_DEFAUT);
    }
    tempsPauseCourte =
        Duration(minutes: tempsPauseCourteMinutes ?? TEMPS_PAUSE_COURTE_DEFAUT);
    tempsPauseLongue =
        Duration(minutes: tempsPauseLongueMinutes ?? TEMPS_PAUSE_LONGUE_DEFAUT);
  }

  void arreterMinuteur() {
    _estActif = false;
  }

  void relancerMinuteur() {
    if (_temps.inSeconds > 0) {
      _estActif = true;
    } else {
      _temps = _tempsTotal;
      _estActif = true;
    }
  }

  void demarrerPause(bool estCourte) {
    _estActif = true;
    if (estCourte) {
      _temps = tempsPauseCourte;
      _tempsTotal = tempsPauseCourte;
    } else {
      _temps = tempsPauseLongue;
      _tempsTotal = tempsPauseLongue;
    }
  }
}

class BoutonGenerique extends StatelessWidget {
  final Color couleur;
  final String texte;
  final double taille;
  final VoidCallback action;

  const BoutonGenerique({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.taille,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      color: couleur,
      minWidth: taille,
      height: 60.0,
      child: Text(
        texte,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class PageAccueilMinuterie extends StatefulWidget {
  final Function()? onParametresChanged;

  PageAccueilMinuterie({Key? key, this.onParametresChanged})
      : super(key: key);

  @override
  _PageAccueilMinuterieState createState() => _PageAccueilMinuterieState();
}

class _PageAccueilMinuterieState extends State<PageAccueilMinuterie> {
  static const double REMPLISSAGE_DEFAUT = 5.0;
  final minuteur = Minuteur();
  int tempsPauseCourte = TEMPS_PAUSE_COURTE_DEFAUT;
  int tempsPauseLongue = TEMPS_PAUSE_LONGUE_DEFAUT;

  void allerParametres(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Parametres(onParametresChanged: majParametres)),
    );
  }

  void majParametres() {
    setState(() {
      minuteur.tempsPauseCourte = Duration(minutes: tempsPauseCourte);
      minuteur.tempsPauseLongue = Duration(minutes: tempsPauseLongue);
    });
    if (widget.onParametresChanged != null) {
      widget.onParametresChanged!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> elementsMenu = [];
    elementsMenu.add(const PopupMenuItem(
      value: 'Param',
      child: Text('Paramètres'),
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Minuterie'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return elementsMenu.toList();
            },
            onSelected: (s) {
              if (s == 'Param') {
                allerParametres(context);
              }
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints) {
          final double largeurDisponible = contraints.maxWidth;
          return Padding(
            padding: const EdgeInsets.all(REMPLISSAGE_DEFAUT),
            child: Column(
              children: <Widget>[
                // Boutons du haut
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(REMPLISSAGE_DEFAUT),
                        child: BoutonGenerique(
                          couleur: Colors.blueAccent,
                          texte: 'Travail',
                          taille: 100.0,
                          action: () {
                            setState(() {
                              minuteur._temps = const Duration(minutes: 30);
                              minuteur._tempsTotal =
                                  const Duration(minutes: 30);
                              minuteur.relancerMinuteur();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(REMPLISSAGE_DEFAUT),
                        child: BoutonGenerique(
                          couleur: Colors.white,
                          texte: 'Mini pause',
                          taille: 100.0,
                          action: () {
                            setState(() {
                              minuteur.demarrerPause(true);
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(REMPLISSAGE_DEFAUT),
                        child: BoutonGenerique(
                          couleur: Colors.red,
                          texte: 'Maxi pause',
                          taille: 100.0,
                          action: () {
                            setState(() {
                              minuteur.demarrerPause(false);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Minuterie
                Expanded(
                  child: StreamBuilder<ModeleMinuteur>(
                    stream: minuteur.stream(),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      return CircularPercentIndicator(
                        radius: (largeurDisponible - 60.0) / 5.0,
                        lineWidth: 10.0,
                        percent: data?.pourcentage ?? 1,
                        center: Text(
                          data?.temps ?? '30:00',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        progressColor: const Color(0xff022bff),
                      );
                    },
                  ),
                ),
// Boutons du bas
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(REMPLISSAGE_DEFAUT),
                        child: BoutonGenerique(
                          couleur: Colors.blueAccent,
                          texte: 'Arrêter',
                          taille: 100.0,
                          action: minuteur.arreterMinuteur,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(REMPLISSAGE_DEFAUT),
                        child: BoutonGenerique(
                          couleur: Colors.red,
                          texte: 'Relancer',
                          taille: 100.0,
                          action: minuteur.relancerMinuteur,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
