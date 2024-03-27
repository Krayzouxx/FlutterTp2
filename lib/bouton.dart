import 'package:flutter/material.dart';

class BoutonGenerique extends StatelessWidget {
  final Color couleur;
  final String texte;
  final double taille;
  final VoidCallback action;

  const BoutonGenerique({
    super.key,
    required this.couleur,
    required this.texte,
    required this.taille,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      color: couleur,
      minWidth: taille,
      height: 60.0,
      child: Text(
        texte,
        style: TextStyle(
        ),
      ),
    );
  }
}

typedef CallbackSetting = void Function(String, int);

class BoutonParametre extends StatelessWidget {
  final Color couleur;
  final String texte;
  final int valeur;
  final String parametre;
  final CallbackSetting action;
  final ValueChanged<int>? onValueChanged;
  final Color couleurTexte;

  const BoutonParametre({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.valeur,
    required this.parametre,
    required this.action,
    this.onValueChanged,
    this.couleurTexte = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        action(parametre, valeur);
        if (onValueChanged != null) {
          onValueChanged!(valeur);
        }
      },
      color: couleur,
      child: Text(
        texte,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
