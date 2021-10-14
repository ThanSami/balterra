import 'package:balterra/constantes.dart';
import 'package:flutter/material.dart';
import 'package:balterra/login.dart';
void main() => runApp(new BalterraApp());

class BalterraApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new LoginPage(),
        theme: new ThemeData(
            primarySwatch: Constantes.colorPrimario
        )
    );
  }

}