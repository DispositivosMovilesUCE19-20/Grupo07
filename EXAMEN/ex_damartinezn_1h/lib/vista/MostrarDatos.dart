import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:proyecto_final_g07/controlador/DBHelper.dart';
import 'package:proyecto_final_g07/controlador/Utility.dart';
import 'package:proyecto_final_g07/modelo/Mensaje.dart';
import 'package:proyecto_final_g07/modelo/User.dart';
import 'package:proyecto_final_g07/rest/mensaje_provider.dart';
import 'package:toast/toast.dart';

import 'ModificarUser.dart';


class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}

class MostrarDatos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MostrarPage(),
    );
  }
}

class MostrarPage extends StatefulWidget {
  User usuario;
  MostrarPage({Key key, this.usuario}) : super(key: key);
  @override
  _MostrarPageState createState() => _MostrarPageState();
}

class _MostrarPageState extends State<MostrarPage> {
  //metodo para el ptah de la apliacion para poder crear el archivo
  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    new Directory(appDocDirectory.path + '/' + 'dir')
        .create(recursive: true)
        .then((Directory directory) {
      print('Path of New Dir: ' + directory.path);
    });
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.json');
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  //declaramos todas las variables a utilizar

  DBHelper dbHelper;
  User user;
  User aux;

  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  Mensaje auxMensaje;
  String mensajeText;

  @override
  void initState() {
    super.initState();
    //mensaje rest

    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          auxMensaje = new Mensaje(lisMensaje[0].msg);
          mensajeText = auxMensaje.msg.toString();
        });
      }
    });

    //***********************
    dbHelper = DBHelper();
    user = widget.usuario;
    setState(() {
      aux = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    int value;
    return Scaffold(
      appBar: AppBar(
        title: Text("Datos del Usuario"),
        actions: <Widget>[
          PopupMenuButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            onSelected: onChoice,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Loguin"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Salir"),
              ),
            ],
          )
        ],
      ),
      backgroundColor: Colors.blue[700],
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Column(
              children: <Widget>[
                if (mensajeText == null)
                  CircularProgressIndicator()
                else
                  Text(
                    "${mensajeText}", // ignore: unnecessary_brace_in_string_interps
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                if (Utility.imageFromBase64String(aux.foto) != null)
                  SizedBox(
                    height: 150,
                    child: Utility.imageFromBase64String(aux.foto),
                  ),
              ],
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
            padding: EdgeInsets.all(10),
            decoration: new BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.lightBlueAccent[200],
                  offset: new Offset(10.0, 10.0),
                  blurRadius: 30.0,
                )
              ],
              borderRadius: new BorderRadius.circular(30),
              color: Colors.lightBlue[200],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        hintText: "Nombre : ${aux.name}",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        hintText: "Apellido : ${aux.apellido}",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        hintText: "Cédula : ${aux.cedula}",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.contact_mail),
                        hintText: "Correo : ${aux.correo}",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.home),
                        hintText: "Dirección : ${aux.direccion}",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: new RaisedButton(
                      hoverElevation: 200,
                      splashColor: Colors.blueAccent,
                      child: new Text(
                        'Modificar Usuario',
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      onPressed: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new UpdatePage(usuario: aux),
                        );
                        Navigator.of(context).pushReplacement(route);
                      },
                      color: Colors.amber[100],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  onChoice(int value) {
    if (value == 1) {
      //Navigator.popUntil(context, ModalRoute.withName('/Header'));
      Navigator.of(context).pushNamedAndRemoveUntil('/Header', ModalRoute.withName('/MostrarDatos'));
      //Navigator.of(context).pushNamed('/Header');
    } else {
      exit(0);
    }
  }
}
