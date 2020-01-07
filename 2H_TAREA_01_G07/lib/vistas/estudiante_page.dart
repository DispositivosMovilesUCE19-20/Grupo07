import 'package:flutter/material.dart';

class EstudiantePage extends StatefulWidget {
  EstudiantePage({Key key}) : super(key: key);

  @override
  _EstudiantePageState createState() => _EstudiantePageState();
}

class _EstudiantePageState extends State<EstudiantePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Modulo de Estudiantes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.person,
            color: Colors.white,),
          )
        ],
      ),
    );
  }
}
