import 'package:flutter/material.dart';
import 'package:trabajo03v2/vistas/Header.dart';
import 'package:trabajo03v2/vistas/MostrarDatos.dart';
import 'package:trabajo03v2/vistas/RegistroUsuarios.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    '/Header': (context) => MostrarLogin(),
    '/RegistrarUsuario': (context) => RegistroPage(),
    '/MostrarDatos': (context) => MostrarPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MostrarLogin(),
      routes: routes,
    );
  }
}
