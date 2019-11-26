import 'package:flutter/material.dart';
import 'package:proyecto_final_g07/vista/Header.dart';
import 'package:proyecto_final_g07/vista/MostrarDatos.dart';
import 'package:proyecto_final_g07/vista/RegistroUsuarios.dart';
import 'package:proyecto_final_g07/vista/listadoUsuarios.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final routes = <String, WidgetBuilder>{
    '/Header': (context) => MostrarLogin(),
    '/RegistrarUsuario': (context) => RegistroPage(),
    '/MostrarDatos': (context) => MostrarPage(),
    '/listadoUsuarios':(context) => ListadoPage(),
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
