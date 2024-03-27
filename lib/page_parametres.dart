import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bouton.dart';
import 'main.dart';

class Parametres extends StatefulWidget {
  final Function? onParametresChanged;

  Parametres({this.onParametresChanged});

  @override
  _ParametresState createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  int tempsTravail = 30;
  int pauseCourte = 5;
  int pauseLongue = 20;

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
      tempsTravail = preferences.getInt(CLE_TEMPS_TRAVAIL) ?? TEMPS_TRAVAIL_DEFAUT;
      pauseCourte = preferences.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
      pauseLongue = preferences.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;

      txtTempsTravail.text = tempsTravail.toString();
      txtTempsPauseCourte.text = pauseCourte.toString();
      txtTempsPauseLongue.text = pauseLongue.toString();
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
        await lireParametres(); // Mettre à jour les valeurs après les avoir modifiées.
      }
    } else if (cle == CLE_PAUSE_COURTE) {
      temps = preferences.getInt(CLE_PAUSE_COURTE) ?? TEMPS_PAUSE_COURTE_DEFAUT;
      temps += value;
      if (temps >= 1 && temps <= 180) {
        preferences.setInt(CLE_PAUSE_COURTE, temps);
        await lireParametres(); // Mettre à jour les valeurs après les avoir modifiées.
      }
    } else if (cle == CLE_PAUSE_LONGUE) {
      temps = preferences.getInt(CLE_PAUSE_LONGUE) ?? TEMPS_PAUSE_LONGUE_DEFAUT;
      temps += value;
      if (temps >= 1 && temps <= 180) {
        preferences.setInt(CLE_PAUSE_LONGUE, temps);
        await lireParametres(); // Mettre à jour les valeurs après les avoir modifiées.
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
              hintText: tempsTravail.toString(),
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
              hintText: pauseCourte.toString(),
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
              hintText: pauseLongue.toString(),
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