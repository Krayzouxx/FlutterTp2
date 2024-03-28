import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bouton.dart';
import 'variables_globales.dart' as globals;



const String CLE_TEMPS_TRAVAIL = 'Temps de travail';
const String CLE_PAUSE_COURTE = 'Pause courte';
const String CLE_PAUSE_LONGUE = 'Pause longue';

const int TEMPS_PAUSE_COURTE_DEFAUT = 5; // 5 minutes
const int TEMPS_PAUSE_LONGUE_DEFAUT = 20; // 20 minutes
const int TEMPS_TRAVAIL_DEFAUT = 30; // 30 minutes

class Parametres extends StatefulWidget {
  final Function? onParametresChanged;

  Parametres({this.onParametresChanged});

  @override
  _ParametresState createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {

  TextEditingController txtTempsTravail = TextEditingController();
  TextEditingController txtTempsPauseCourte = TextEditingController();
  TextEditingController txtTempsPauseLongue = TextEditingController();

  @override
  void initState() {
    super.initState();
    lireParametres();
  }

  Future<void> lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      globals.temps_travail = preferences.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
      globals.temps_mini = preferences.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
      globals.temps_maxi = preferences.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;

      txtTempsTravail.text = globals.temps_travail.toString();
      txtTempsPauseCourte.text = globals.temps_mini.toString();
      txtTempsPauseLongue.text = globals.temps_maxi.toString();
    });
  }

  Future<void> majParametres(String cle, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int temps;

    if (cle == CLE_TEMPS_TRAVAIL) {
      temps = preferences.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
      temps += value;
      if (temps >= 1 && temps <= 180) {
        preferences.setInt(CLE_TEMPS_TRAVAIL, temps);
        await lireParametres();
      }
    } else if (cle == CLE_PAUSE_COURTE) {
      temps = preferences.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
      temps += value;
      if (temps >= 1 && temps <= 180) {
        preferences.setInt(CLE_PAUSE_COURTE, temps);
        await lireParametres();
      }
    } else if (cle == CLE_PAUSE_LONGUE) {
      temps = preferences.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;
      temps += value;
      if (temps >= 1 && temps <= 180) {
        preferences.setInt(CLE_PAUSE_LONGUE, temps);
        await lireParametres();
      }
    }

    // Après la mise à jour des paramètres, appelez le callback si il est défini
    if (widget.onParametresChanged != null) {
      widget.onParametresChanged?.call();
    }
  }

  @override
  void dispose() {
    txtTempsTravail.dispose();
    txtTempsPauseCourte.dispose();
    txtTempsPauseLongue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle styleTexte = TextStyle(fontSize: 24);
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: GridView
          .count(
        crossAxisCount: 3,
        childAspectRatio: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: EdgeInsets.all(20),
        children: <Widget>[
          Text('Temps de travail', style: styleTexte),
          Text(''),
          Text(''),
          BoutonParametre(
            couleur: Colors.pink,
            texte: '-',
            valeur: -1,
            parametre: CLE_TEMPS_TRAVAIL,
            action: majParametres,
          ),
          TextField(
            controller: txtTempsTravail,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: globals.temps_travail.toString(),
            ),
            onChanged: (value) {
              setState(() {
                txtTempsTravail.text = value;
              });
            },
          ),
          BoutonParametre(
            couleur: Colors.pinkAccent,
            texte: '+',
            valeur: 1,
            parametre: CLE_TEMPS_TRAVAIL,
            action: majParametres,
          ),
          BoutonParametre(
            couleur: Colors.pink,
            texte: '-',
            valeur: -1,
            parametre: CLE_PAUSE_COURTE,
            action: majParametres,
          ),
          TextField(
            controller: txtTempsPauseCourte,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: globals.temps_mini.toString(),
            ),
            onChanged: (value) {
              setState(() {
                txtTempsPauseCourte.text = value;
              });
            },
          ),
          BoutonParametre(
            couleur: Colors.pinkAccent,
            texte: '+',
            valeur: 1,
            parametre: CLE_PAUSE_COURTE,
            action: majParametres,
          ),
          BoutonParametre(
            couleur: Colors.pink,
            texte: '-',
            valeur: -1,
            parametre: CLE_PAUSE_LONGUE,
            action: majParametres,
          ),
          TextField(
            controller: txtTempsPauseLongue,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: globals.temps_maxi.toString(),
            ),
            onChanged: (value) {
              setState(() {
                txtTempsPauseLongue.text = value;
              });
            },
          ),
          BoutonParametre(
            couleur: Colors.pinkAccent,
            texte: '+',
            valeur: 1,
            parametre: CLE_PAUSE_LONGUE,
            action: majParametres,
          ),
        ],
      ),
    );
  }
}