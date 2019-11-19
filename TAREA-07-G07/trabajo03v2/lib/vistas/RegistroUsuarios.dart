import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trabajo03v2/bdhelper/DBHelper.dart';
import 'package:trabajo03v2/bdhelper/Utility.dart';
import 'package:trabajo03v2/modelo/User.dart';

class RegistroUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: RegistroPage(),
    );
  }
}

class RegistroPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<RegistroPage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formStateKey1 = GlobalKey<FormState>();
//declaramos todas las variables a utilizar
  DBHelper dbHelper;
//variables para el form
  String nombre, apellido, cedula, correo, direccion, user, pass, sexo, fecha, matematicas, fisica,quimica, algebra, analisis;
  bool asignaturas = false, asignaturas1 = false, asignaturas2 = false,asignaturas3 = false,asignaturas4 = false, beca = false;

  DateTime _date = DateTime.now();

//controller para regresar a txt
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final correoController = TextEditingController();
  final direccionController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();

  File _selectedPicture;
  String auxImagen;
  String selectedRadio;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    selectedRadio = "";
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuarios'),
      ),
      backgroundColor: Colors.blue[700],
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                if (_selectedPicture != null)
                  SizedBox(
                    height: 150,
                    child: Image.file(_selectedPicture),
                  ),
              ],
            ),
          ),
          componentes(),
        ],
      ),
    );
  }

  Future<Null> selectDate () async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1978),
        lastDate: DateTime(2090),
    );
    if(picked != null && picked != _date){
      setState(() {
        _date = picked;
        fecha = _date.toString();
        print(_date.toString());
      });
    }
  }

  Future<String> fechaCumple() async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1978),
      lastDate: DateTime(2090),
    );
    if(picked != null && picked != _date){
      setState(() {
        _date = picked;
        fecha = _date.toString();
        print(_date.toString());
        return _date.toString();
      });
    }
  }


  IconButton imagenCargar() {
    return new IconButton(
        icon: Icon(
          Icons.camera_alt,
          size: 50,
        ),
        color: Colors.deepOrange[300],
        onPressed: () async {
          var imagen = await ImagePicker.pickImage(source: ImageSource.gallery);
          setState(() {
            _selectedPicture = imagen;
          });
        });
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
    });
  }



  Column retornarSexo() {
    return Column(
      children: <Widget>[
        Text("Sellecione el género"),
        RadioListTile(
          value: "Hombre",
          groupValue: selectedRadio,
          title: Text("Masculino"),
          onChanged: (val) {
            setSelectedRadio(val);
            print("$val");
          },
          activeColor: Colors.red,
        ),
        RadioListTile(
          value: "Mujer",
          groupValue: selectedRadio,
          title: Text("Femenino"),
          onChanged: (val) {
            setSelectedRadio(val);
            print("$val");
          },
          activeColor: Colors.red,
        ),
      ],
    );
  }

  SingleChildScrollView componentes() {
    return SingleChildScrollView(
      child: Container(
        margin: new EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.lightBlueAccent[100],
              offset: new Offset(10.0, 10.0),
              blurRadius: 30.0,
            )
          ],
          borderRadius: new BorderRadius.circular(30),
          color: Colors.lightBlue[200],
        ),
        child: new Form(
          key: _formStateKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              imagenCargar(),
              new Text("Seleccione una imagen"),
              Divider(
                height: 25,
                color: Colors.black,
                endIndent: 5,
                indent: 5,
                thickness: 2,
              ),
              Text("INFORMACION PERSONAL"),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Ingrese su nombre'),
                validator: (value) =>
                    value.isEmpty ? 'Ingrese el nombre.' : null,
                onSaved: (value) => nombre = value,
              ),
              new TextFormField(
                decoration:
                    new InputDecoration(labelText: 'Ingrese su apellido'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese el apellido.' : null,
                onSaved: (value) => apellido = value,
              ),
              new TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    new InputDecoration(labelText: 'Ingrese su celular'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese su celular' : null,
                onSaved: (value) => cedula = value,
              ),
              new TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(labelText: 'Ingrese el correo'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese el correo.' : null,
                onSaved: (value) => correo = value,
              ),

              Divider(
                height: 25,
                color: Colors.black,
                endIndent: 5,
                indent: 5,
                thickness: 2,
              ),
              retornarSexo(),

              IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: (){
                    selectDate();
                  }
              ),
              Text("Seleccione una fecha"),

              new TextFormField(
                decoration: new InputDecoration(
                    hintText: '$fecha',
                ),
                validator: (value) =>
                value.isEmpty ? 'Ingrese una fecha.' : 'Ingrese una fecha',
                onSaved: (value) => fecha = value,
              ),
              Text(""),
              Text("Seleccione las asignaturas"),
              new Container(
                child: Row(
                  children: <Widget>[
                    Text("Matematicas"),
                    new Checkbox(
                      value: asignaturas,
                      onChanged: (bool resp){
                        setState(() {
                          asignaturas = resp;
                          if(resp == true){
                            matematicas = "Matematicas";
                          }
                        });
                      },
                    ),
                    Text("Fisica"),
                    new Checkbox(
                      value: asignaturas1,
                      onChanged: (bool resp){
                        setState(() {
                          asignaturas1=resp;
                          if(resp == true){
                            fisica = "Fisica";
                          }
                        });
                      },
                    ),
                    Text("Quimica"),
                    new Checkbox(
                      value: asignaturas2,
                      onChanged: (bool resp){
                        setState(() {
                          asignaturas2=resp;
                          if(resp == true){
                            fisica = "Quimica";
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              new Container(
                child: Row(
                  children: <Widget>[
                    Text("Analisis"),
                    new Checkbox(
                      value: asignaturas3,
                      onChanged: (bool resp){
                        setState(() {
                          asignaturas3 = resp;
                          if(resp == true){
                            analisis = "Analisis";
                          }
                        });
                      },
                    ),
                    Text("Algebra"),
                    new Checkbox(
                      value: asignaturas4,
                      onChanged: (bool resp){
                        setState(() {
                          asignaturas4=resp;
                          if(resp == true){
                            algebra = "Algebra";
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Text(""),
              Text("Es becado."),
              new Switch(
                  value: beca,
                  onChanged: (bool resp){
                    setState(() {
                      beca = resp;
                      print("$beca");
                    });
                  },
              ),
              Divider(
                height: 25,
                color: Colors.black,
                endIndent: 5,
                indent: 5,
                thickness: 2,
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Ingrese usuario'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese un usuario.' : null,
                onSaved: (value) => user = value,
              ),
              new TextFormField(
                decoration:
                    new InputDecoration(labelText: 'Ingrese una contraseña'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese una contraseña.' : null,
                onSaved: (value) => pass = value,
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration:
                    new BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: new RaisedButton(
                  hoverElevation: 200,
                  splashColor: Colors.blueAccent,
                  child: new Text(
                    'Registrar Usuario',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    if (_formStateKey.currentState.validate()) {
                      _formStateKey.currentState.save();
                      auxImagen = Utility.base64String(
                          _selectedPicture.readAsBytesSync());
                      dbHelper.newClient(User(null, nombre, apellido, cedula,
                          correo, direccion, auxImagen, user, pass));
                      _formStateKey.currentState.reset();
                      Navigator.of(context).pushNamed('/Header');
                    }
                  },
                  color: Colors.amber[100],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


