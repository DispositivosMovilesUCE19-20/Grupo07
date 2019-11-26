import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_final_g07/controlador/DBHelper.dart';
import 'package:proyecto_final_g07/controlador/Utility.dart';
import 'package:proyecto_final_g07/modelo/Mensaje.dart';
import 'package:proyecto_final_g07/modelo/User.dart';
import 'package:proyecto_final_g07/rest/mensaje_provider.dart';
import 'package:toast/toast.dart';


import 'MostrarDatos.dart';

class UpdateUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: UpdatePage(),
    );
  }
}

class UpdatePage extends StatefulWidget {
  User usuario;
  UpdatePage({Key key, this.usuario}) : super(key: key);
  @override
  _StudentPageUpdate createState() => _StudentPageUpdate();
}

class _StudentPageUpdate extends State<UpdatePage> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

//declaramos todas las variables a utilizar
  DBHelper dbHelper;
//variables para el form
  String nombre, apellido, cedula, correo, direccion, user, pass, sexo, fecha;
  bool asignaturas = false,
      asignaturas1 = false,
      asignaturas2 = false,
      asignaturas3 = false,
      asignaturas4 = false,
      beca = false;
  int mat = 0, mat1 = 0, mat2 = 0, mat3 = 0, mat4 = 0;
  DateTime _date = DateTime.now();

//controller para regresar a txt
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final celularController = TextEditingController();
  final correoController = TextEditingController();
  final direccionController = TextEditingController();
  final fechaController = TextEditingController();
  final sexoController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();

  File _selectedPicture;
  String auxImagen;
  String selectedRadio;
  User aux;

  activarMateriss(String materias) {
    mat = int.parse(materias.toString().substring(0, 1));
    mat1 = int.parse(materias.toString().substring(1, 2));
    mat2 = int.parse(materias.toString().substring(2, 3));
    mat3 = int.parse(materias.toString().substring(3, 4));
    mat4 = int.parse(materias.toString().substring(4, 5));
    if (mat == 1) {
      setState(() {
        asignaturas = true;
      });
    } else {
      asignaturas = false;
    }
    if (mat1 == 1) {
      setState(() {
        asignaturas1 = true;
      });
    } else {
      asignaturas1 = false;
    }
    if (mat2 == 1) {
      setState(() {
        asignaturas2 = true;
      });
    } else {
      asignaturas2 = false;
    }
    if (mat3 == 1) {
      setState(() {
        asignaturas3 = true;
      });
    } else {
      asignaturas3 = false;
    }
    if (mat4 == 1) {
      setState(() {
        asignaturas4 = true;
      });
    } else {
      asignaturas4 = false;
    }
  }

  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  Mensaje auxMensaje;
  String mensajeText, mensajeTextU, mensajeTextUE;
  final String url = "mensajeEditado";
  final String urlE = "mensajeErrorEditado";
  User usuario;

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

    //****************************************************
    lista = mensajeProvider.mensajeImprimir(url);
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          auxMensaje = new Mensaje(lisMensaje[0].msg);
          mensajeTextU = auxMensaje.msg.toString();
        });
      }
    });
    //*****************************************************
    lista = mensajeProvider.mensajeImprimir(url);
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          auxMensaje = new Mensaje(lisMensaje[0].msg);
          mensajeTextUE = auxMensaje.msg.toString();
        });
      }
    });
    //****************************************************
    dbHelper = DBHelper();
    selectedRadio = "";
    setState(() {
      aux = widget.usuario;
    });
    usuario = aux;
    print(aux.toMap());
    fechaController.text = aux.fecha;
    nombreController.text = aux.name;
    apellidoController.text = aux.apellido;
    celularController.text = aux.cedula;
    correoController.text = aux.correo;
    direccionController.text = aux.direccion;
    selectedRadio = aux.sexo.toString();

    activarMateriss(aux.materias);
    userController.text = aux.user;
    passController.text = aux.password;
    if (aux.beca == "true") {
      beca = true;
    } else {
      beca = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Usuario'),
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
                if (_selectedPicture == null)
                  SizedBox(
                    height: 150,
                    child: Utility.imageFromBase64String(aux.foto),
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
        fechaController.text = _date.toString().substring(0, 11);
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
                controller: nombreController,
              ),
              new TextFormField(
                decoration:
                    new InputDecoration(labelText: 'Ingrese su apellido'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese el apellido.' : null,
                onSaved: (value) => apellido = value,
                controller: apellidoController,
              ),
              new TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    new InputDecoration(labelText: 'Ingrese su celular'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese su celular' : null,
                onSaved: (value) => cedula = value,
                controller: celularController,
              ),
              new TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: new InputDecoration(labelText: 'Ingrese el correo'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese el correo.' : null,
                onSaved: (value) => correo = value,
                controller: correoController,
              ),
              new TextFormField(
                keyboardType: TextInputType.text,
                decoration:
                    new InputDecoration(labelText: 'Ingrese la direccion'),
                //obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese una direccion.' : null,
                onSaved: (value) => direccion = value,
                controller: direccionController,
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
                decoration: new InputDecoration(labelText: 'Ingrese una fecha'),
                //validator: (value) =>
                //value.isEmpty ? 'Ingrese una fecha.' : 'Ingrese una fecha',
                onSaved: (value) => fecha = value,
                controller: fechaController,
              ),
              Text(""),
              Text("Seleccione las asignaturas"),
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
                controller: userController,
              ),
              new TextFormField(
                decoration:
                    new InputDecoration(labelText: 'Ingrese una contraseña'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese una contraseña.' : null,
                onSaved: (value) => pass = value,
                controller: passController,
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration:
                    new BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: new RaisedButton(
                  hoverElevation: 200,
                  splashColor: Colors.blueAccent,
                  child: new Text(
                    'Modificar Usuario',
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
                        if (_selectedPicture != null) {
                          auxImagen = Utility.base64String(
                              _selectedPicture.readAsBytesSync());
                        } else {
                          auxImagen = aux.foto;
                        }
                        int idUser = aux.id;
                        print(fecha);
                        User update = User(
                            null,
                            nombre,
                            apellido,
                            cedula,
                            correo,
                            direccion,
                            auxImagen,
                            selectedRadio,
                            fecha,
                            beca.toString(),
                            auxMaterias,
                            user,
                            pass);
                        dbHelper.updateClient(update, idUser).then((int res) {
                          print(res);
                          if (res != null) {
                            _formStateKey.currentState.reset();
                            Toast.show(
                                mensajeTextU,
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            Navigator.of(context).pushNamedAndRemoveUntil('/listadoUsuarios', ModalRoute.withName('/MostrarDatos'));
                            //Navigator.popUntil(context, ModalRoute.withName('/listadoUsuarios'));
                          } else {
                            Toast.show(
                                mensajeTextUE,
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);;
                          }
                        });
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
