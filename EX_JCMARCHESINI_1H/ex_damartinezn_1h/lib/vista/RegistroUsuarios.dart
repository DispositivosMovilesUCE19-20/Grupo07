import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final_g07/controlador/DBHelper.dart';
import 'package:proyecto_final_g07/controlador/Utility.dart';
import 'package:proyecto_final_g07/modelo/Mensaje.dart';
import 'package:proyecto_final_g07/modelo/User.dart';
import 'package:proyecto_final_g07/rest/mensaje_provider.dart';
import 'package:toast/toast.dart';

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
  String nombre,
      apellido,
      cedula,
      correo,
      direccion,
      user,
      pass,
      sexo,
      fecha,
      fechaAux,
      matematicas = "",
      fisica = "",
      quimica = "",
      algebra = "",
      analisis = "";
  bool asignaturas,
      asignaturas1,
      asignaturas2,
      asignaturas3,
      asignaturas4,
      beca = false;
  int mat = 0, mat1 = 0, mat2 = 0, mat3 = 0, mat4 = 0;

  DateTime _date = DateTime.now();

//controller para regresar a txt
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final cedulaController = TextEditingController();
  final correoController = TextEditingController();
  final direccionController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final fechaController = TextEditingController();

  File _selectedPicture;
  String auxImagen;
  String selectedRadio;
  Future<int> resul;


  trueVariables() {
    asignaturas = true;
    asignaturas2 = true;
    asignaturas4 = true;
    asignaturas3 = true;
    asignaturas1 = true;
  }

  falseVariables() {
    asignaturas = false;
    asignaturas1 = false;
    asignaturas2 = false;
    asignaturas3 = false;
    asignaturas4 = false;
  }

  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  Mensaje auxMensaje;
  String mensajeText;

  @override
  void initState() {
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

    super.initState();
    dbHelper = DBHelper();
    trueVariables();
    selectedRadio = "";
    falseVariables();
    mat = 0;
    mat1 = 0;
    mat2 = 0;
    mat3 = 0;
    mat4 = 0;
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

  Future<Null> selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1978),
      lastDate: DateTime(2090),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
        fechaController.text = _date.toString().substring(0, 10);
        print(_date.toString());
      });
    }
  }

  Future<String> fechaCumple() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1978),
      lastDate: DateTime(2090),
    );
    if (picked != null && picked != _date) {
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
      sexo = selectedRadio;
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
        margin:
            new EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 25),
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.lightBlueAccent[100],
              offset: new Offset(10.0, 10.0),
              blurRadius: 20.0,
            )
          ],
          borderRadius: new BorderRadius.circular(30),
          color: Colors.white30,
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
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration:
                    new InputDecoration(labelText: 'Ingrese la direccion'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese una direccion.' : null,
                onSaved: (value) => direccion = value,
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
                  onPressed: () {
                    selectDate();
                  }),
              Text("Seleccione una fecha"),
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(labelText: 'Ingrese una fecha'),
                //onTap: selectDate,
                //validator: (value) =>
                //value.isEmpty ? 'Ingrese una fecha.' : 'Ingrese una fecha',
                onSaved: (value) => fecha = value,
                controller: fechaController,
              ),
              Text(""),
              Text("Seleccione las asignaturas"),
              Text(""),
              Container(
                height: 120,
                width: 320,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10),
                  color: Colors.lightBlueAccent[100],
                ),
                child: ListView(
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text("Quimica"),
                      value: asignaturas,
                      onChanged: (bool value) {
                        setState(() {
                          if (value == true) {
                            asignaturas = true;
                            mat = 1;
                          }
                          if (value != true) {
                            asignaturas = false;
                            mat = 0;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Fisica"),
                      value: asignaturas1,
                      onChanged: (bool value1) {
                        setState(() {
                          if (value1 == true) {
                            asignaturas1 = true;
                            mat1 = 1;
                          }
                          if (value1 != true) {
                            asignaturas1 = false;
                            mat1 = 0;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Algebra"),
                      value: asignaturas2,
                      onChanged: (bool value3) {
                        setState(() {
                          if (value3 == true) {
                            asignaturas2 = true;
                            mat2 = 1;
                          }
                          if (value3 != true) {
                            asignaturas2 = false;
                            mat2 = 0;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Historia"),
                      value: asignaturas3,
                      onChanged: (bool value4) {
                        setState(() {
                          if (value4 == true) {
                            asignaturas3 = true;
                            mat3 = 1;
                          }
                          if (value4 != true) {
                            asignaturas3 = false;
                            mat3 = 0;
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Ecuaciones"),
                      value: asignaturas4,
                      onChanged: (bool value5) {
                        setState(() {
                          if (value5 == true) {
                            asignaturas4 = true;
                            mat4 = 1;
                          }
                          if (value5 != true) {
                            asignaturas4 = false;
                            mat4 = 0;
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
                onChanged: (bool resp) {
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
                    int suma = mat + mat1 + mat2 + mat3 + mat4;
                    String auxMaterias;
                    if (suma >= 2) {
                      auxMaterias = mat.toString() +
                          mat1.toString() +
                          mat2.toString() +
                          mat3.toString() +
                          mat4.toString();
                      print(auxMaterias);
                      if (_formStateKey.currentState.validate()) {
                        _formStateKey.currentState.save();

                        auxImagen = Utility.base64String(
                            _selectedPicture.readAsBytesSync());
                        dbHelper.newClient(User(
                            null,
                            nombre,
                            apellido,
                            cedula,
                            correo,
                            direccion,
                            auxImagen,
                            sexo,
                            fecha,
                            beca.toString(),
                            auxMaterias,
                            user,
                            pass));

                        _formStateKey.currentState.reset();
                        resul = mensajeProvider.makePostRequest(User(
                            null,
                            nombre,
                            apellido,
                            cedula,
                            correo,
                            direccion,
                            auxImagen,
                            sexo,
                            fecha,
                            beca.toString(),
                            auxMaterias,
                            user,
                            pass));
                        resul.then((int lisMensaje) {
                          if (lisMensaje > 0 ) {
                            print(lisMensaje);
                          }
                        });
                        Navigator.of(context).pushNamed('/Header');

                      }
                    } else {
                      Toast.show(
                          "Debe seleccionar al menos dos materias", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
