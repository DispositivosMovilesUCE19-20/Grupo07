import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';
import 'package:trabajo03v2/bdhelper/DBHelper.dart';
import 'package:trabajo03v2/bdhelper/Utility.dart';
import 'package:trabajo03v2/modelo/User.dart';


class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}

class MostrarDatos extends StatelessWidget{

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
  final Future<List<User>> usuario;
   Future<List<User>> user2;
  //final Future<User> usuario;
  MostrarPage({Key key, this.usuario}):super(key: key);


   @override
  _MostrarPageState createState() => _MostrarPageState();
}



class _MostrarPageState extends State<MostrarPage>{

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();

    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    new Directory(appDocDirectory.path+'/'+'dir').create(recursive: true)
        .then((Directory directory) {
      print('Path of New Dir: '+directory.path);
    });
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.json');
  }

  Future<File> writeCounter( String counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  //declaramos todas las variables a utilizar

  DBHelper dbHelper;
  Future<List<User>> user;
  User aux;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    user = widget.usuario;
    user.then((List<User> usersList){
      if(usersList != null && usersList.length >0){
        aux = (User(usersList[0].id, usersList[0].name, usersList[0].apellido, usersList[0].cedula, usersList[0].correo, usersList[0].direccion, usersList[0].foto, usersList[0].user, usersList[0].password));
        print("**********   IMPRIMIR COMO SALE ***************");
        print(aux.toMap());
        writeCounter("Nombre : ${aux.name}, Apellido: ${aux.apellido}");
      }
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
                if(Utility.imageFromBase64String(aux.foto) != null)
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
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.black)
                    ),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.supervised_user_circle),
                        hintText: "Apellido : ${aux.apellido}",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.black)
                    ),
                  ),
                  TextField(
                    enabled: false,
                      decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.supervised_user_circle),
                          hintText: "Cédula : ${aux.cedula}",
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.black)
                      ),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.contact_mail),
                        hintText: "Correo : ${aux.correo}",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.black)
                    ),
                  ),
                  TextField(
                    enabled: false,
                    decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.home),
                        hintText: "Dirección : ${aux.direccion}",
                        hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.black)
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
    if(value == 1){
      Navigator.of(context).pushNamed('/Header');
    } else{
      exit(0);
    }
  }
  }



