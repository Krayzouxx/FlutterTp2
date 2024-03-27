import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'main.dart';

class ModeleMinuteur {
  String? temps;
  double? pourcentage;
  ModeleMinuteur(this.temps, this.pourcentage);
}

class Minuteur {
  double _pourcentage = 1.0;
  bool _estActif = false;
  Duration _temps = Duration();
  Duration _tempsTotal = Duration();
  Duration tempsPauseCourte = Duration(minutes: 5);
  Duration tempsPauseLongue = Duration(minutes: 20);

  Minuteur() {
    lireParametres();
  }

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

  lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? tempsPauseCourteMinutes = preferences.getInt(CLE_PAUSE_COURTE);
    if (tempsPauseCourteMinutes == null) {
      await preferences.setInt(CLE_PAUSE_COURTE, TEMPS_PAUSE_COURTE_DEFAUT);
    }
    int? tempsPauseLongueMinutes = preferences.getInt(CLE_PAUSE_LONGUE);
    if (tempsPauseLongueMinutes == null) {
      await preferences.setInt(CLE_PAUSE_LONGUE, TEMPS_PAUSE_LONGUE_DEFAUT);
    }
    tempsPauseCourte = Duration(minutes: tempsPauseCourteMinutes ?? TEMPS_PAUSE_COURTE_DEFAUT);
    tempsPauseLongue = Duration(minutes: tempsPauseLongueMinutes ?? TEMPS_PAUSE_LONGUE_DEFAUT);
  }

  void arreterMinuteur() {
    _estActif = false;
  }

  void relancerMinuteur() async {
    await lireParametres();
    if (_temps.inSeconds > 0) {
      _estActif = true;
    } else {
      _temps = _tempsTotal;
      _estActif = true;
    }
  }

  void demarrerPause(bool estCourte) async {
    await lireParametres();
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


