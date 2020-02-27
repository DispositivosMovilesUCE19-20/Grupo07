import 'dart:io';

import 'package:app_completa3/dbHelper/crud/crud_estudiante.dart';
import 'package:app_completa3/modelo/estudiante.dart';
import 'package:app_completa3/provider/MensajeServicio.dart';
import 'package:app_completa3/utilidades/mensaggeSMS.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_extended/flutter_local_notifications_extended.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:get_it/get_it.dart';

class EstudiantePage extends StatefulWidget {
  @override
  _EstudiantePageState createState() => _EstudiantePageState();
}

class _EstudiantePageState extends State<EstudiantePage> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  //Variable de estado del formulario
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  //Variables para el registro de un nuevo estudiante
  String _nombre;
  String _apellido;
  String _correo;
  String _celular;
  String _fecha;
  int _genero;
  int _becado = 0;

  get flutterLocalNotificationsPlugin => null;

  String formateador(DateTime now) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    print(formatted); // something like 2013-04-20
    return formatted;
  }

  //variable para ver si se actualizo un registro
  int estudianteIdForUpdate;
  //Variable para cambiar el nombre de los botones
  bool isUpdate = false;
  //Variable lista de estudiantes
  Future<List<Estudiante>> estudiantes;
  //Instancia de los metodos crud
  CRUDEstudiante estudianteHelper;
  //Variable para ver como muestra mi lista
  int menu = 1;
  String parametro = 'fecha';

  //metodo de inicializacion
  @override
  void initState() {
    super.initState();
    estudianteHelper = CRUDEstudiante();
    refrescarListaEstudiantes();
    _sendSMS(message, recipents);

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }


   Future _showNotificationWithoutSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      playSound: false, importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Notificación',
    'Este mes es tu cumpleaños',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}

/************************************************************************* */
  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  refrescarListaEstudiantes() {
    setState(() {
      estudiantes = estudianteHelper.getEstudiantes(menu, parametro);
    });
  }

  /******************   MENSAJES DEL SERVICIO GRUPO 07 ********************** */
  /************************************************************************** */
  final mensajeServicio = new MensajeServicio();

  Future<String> obtenerMensajeServicio() async {
    String mensaje = await mensajeServicio.getData('mensajeGrupo07');
    return mensaje;
  }

  String mensajeToast;
  Future<String> obtenerMensajeEliminado() async {
    String mensaje = await mensajeServicio.getData('mensajeEliminado');
    mensajeToast = mensaje;
    return mensaje;
  }

/************************************************************************** */
/************************************************************************** */
/** ******************************ENVIAR EMAIL EDITANDO UNO MISMO ******************** */
/************************************************************************************* */
  //Variables controller
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _celularController = TextEditingController();
  final fechaController = TextEditingController();
  final _generoController = TextEditingController();
  final _becadoController = TextEditingController();

  _sendEmail() async {
    final String _email = 'mailto:' +
        _correoController.text +
        '?subject=' +
        "Ingreso exitoso" +
        '&body=' +
        _nombreController.text +
        "," +
        _apellidoController.text +
        "," +
        _celularController.text;
    try {
      await launch(_email);
    } catch (e) {
      throw 'Could not Call Phone';
    }
  }
  /************************************************************************************************************ */
  /************************************************************************************************************ */

/**   ********************************  ENVIAR   MENSAJE   SMS   flutter_sms: ^0.0.3 *****************************/
/*********************************************************************************************************** */

  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  String message = "This is a test message!";
  List<String> recipents = ["+593 967434952", "+593 967434952"];

/*************************************************************************************************/
/*********************************************************************************************** */

  DateTime _date = DateTime.now();

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
        fechaController.text = formateador(_date);
        print(_date.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      drawer: _drawer(context),
      appBar: _appBar(),

      body: Container(
        child: Column(
          children: <Widget>[
            Center(
              child: FutureBuilder<String>(
                future: obtenerMensajeServicio(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Form(
                        key: _formStateKey,
                        //autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            _textFieldNombre(),
                            _textFielApellido(),
                            _textFieldCorreo(),
                            _textFielCelular(),
                            _switchBecado(),
                            _radioButtonGenero(),
                            IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: () {
                                  selectDate();
                                }),
                            _textFielFecha(),
                            _textFieldCamara()
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _botonRegistrar(),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          _botonCancelar(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 50.0,
            ),
            _listarEstudiantes()
          ],
        ),
      ),
    );
  }

  File _image;
  void open_camera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

/****************************** */
/***********SELECCIONAR BECADO ******** */
  bool _beca = false;

  _switchBecado() {
    if (_becado == 1) {
      _beca = true;
    } else {
      _beca = false;
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.beenhere,
            color: Colors.lightBlue,
          ),
          Text(
            'Becado',
            style: TextStyle(color: Colors.lightBlue),
          ),
          Switch(
              value: _beca,
              onChanged: (_beca) {
                setState(() {
                  if (_beca) {
                    _becado = 1;
                    _beca = true;
                    print('Es becado');
                    print(_beca);
                  } else {
                    _becado = 0;
                    _beca = false;
                    print('No es becado');
                    print(_beca);
                  }
                  print(_becado);
                });
              })
        ],
      ),
    );
  }

/******************************************* */
/****************************************** */
  //selecccionar el genero
  /********************** */
  _radioButtonGenero() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.people,
          color: Colors.lightBlue,
        ),
        Text(
          'Genero',
          style: TextStyle(color: Colors.lightBlue),
        ),
        Radio(
            value: 1,
            groupValue: _genero,
            onChanged: (G) {
              print(G);
              setState(() {
                _genero = G;
              });
            }),
        Text(
          'M',
          style: TextStyle(color: Colors.lightBlue),
        ),
        Radio(
            value: 0,
            groupValue: _genero,
            onChanged: (G) {
              print(G);
              setState(() {
                _genero = G;
              });
            }),
        Text(
          'F',
          style: TextStyle(color: Colors.lightBlue),
        )
      ],
    );
  }

  //conectar la camara
  _textFieldCamara() {
    return Center(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black12,
              height: 300.0,
              width: 900.0,
              child:
                  _image == null ? Text("Still waiting!") : Image.file(_image),
            ),
            FlatButton(
              color: Colors.deepOrangeAccent,
              child: Text(
                "Open Camera",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                open_camera();
              },
            ),
          ],
        ),
      ),
    );
  }

  //textfiel del nombre
  _textFieldNombre() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese el nombre';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _nombre = value;
        },
        controller: _nombreController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Nombre',
            icon: Icon(
              Icons.perm_identity,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

  //Text fiel apellido
  _textFielApellido() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese el Apellido';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _apellido = value;
        },
        controller: _apellidoController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Apellido',
            icon: Icon(
              Icons.perm_identity,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.lightBlue,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

  //textfield para el correo
  _textFieldCorreo() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese el correo';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _correo = value;
        },
        controller: _correoController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Correo',
            icon: Icon(
              Icons.mail,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

  //textfield para el celular
  _textFielCelular() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese el celular';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _celular = value;
        },
        controller: _celularController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Celular',
            icon: Icon(
              Icons.phone,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

  /** *********************************************** */

//textfield para el celular
  _textFielFecha() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese la fecha ';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _fecha = value;
        },
        controller: fechaController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Fecha',
            icon: Icon(
              Icons.calendar_today,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

/************************************************************** */

  //boton para crear el estudiante
  _botonRegistrar() {
    return RaisedButton(
      color: Colors.lightBlue,
      child: Text(
        (isUpdate ? 'Actualizar' : 'Insertar'),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (isUpdate) {
          if (_formStateKey.currentState.validate()) {
            _formStateKey.currentState.save();
            estudianteHelper
                .actualizarEstudiante(Estudiante(estudianteIdForUpdate, _nombre,
                    _apellido, _correo, _celular, _fecha, _genero, _becado))
                .then((data) {
              setState(() {
                isUpdate = false;
              });
            });
          }
        } else {
          if (_formStateKey.currentState.validate()) {
            _formStateKey.currentState.save();
            estudianteHelper.registrarEstudiante(Estudiante(null, _nombre,
                _apellido, _correo, _celular, _fecha, _genero, _becado));
            //_sendEmail();
            print(_fecha);
                
             String fechaActual =  "2020-01-31";
              String fechaAntes = "2020-03-01";
             if (_fecha.compareTo(fechaActual) == 1 && _fecha.compareTo(fechaAntes) == -1) {
              print("este mes es tu cumpleaños");
              //_showNotificationWithoutSound();*
              showToast("este mes es tu cumpleaños",
                                    duracion: Toast.LENGTH_LONG,
                                    gravedad: Toast.BOTTOM);
             }            
            
          }
        }
        _nombreController.text = '';
        _apellidoController.text = '';
        _correoController.text = '';
        _celularController.text = '';
        fechaController.text = '';
        refrescarListaEstudiantes();
      },
    );
  }

  //Boton cancelar o limiar
  _botonCancelar() {
    return RaisedButton(
      color: Colors.lightBlue,
      child: Text(
        (isUpdate ? 'Cancelar' : 'Limpiar'),
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _nombreController.text = '';
        _apellidoController.text = '';
        _correoController.text = '';
        _celularController.text = '';
        fechaController.text = '';
        setState(() {
          isUpdate = false;
          estudianteIdForUpdate = null;
        });
      },
    );
  }

  //Listar los estudiantes
  _listarEstudiantes() {
    return Expanded(
      child: FutureBuilder(
        future: estudiantes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return generarLista(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text('No hay registros');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            child: DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.lightBlueAccent, Colors.blue])),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    size: 110.0,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.lightBlue),
            title: Text(
              'Lista ascendente fecha',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              setState(() {
                menu = 1;
                parametro = 'fecha';
                refrescarListaEstudiantes();
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.lightBlue),
            title: Text(
              'Lista descendente fecha',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              setState(() {
                menu = 0;
                parametro = 'fecha';
                refrescarListaEstudiantes();
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.lightBlue),
            title: Text(
              'Lista ascendente Apellido',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              setState(() {
                menu = 1;
                parametro = 'apellido';
                refrescarListaEstudiantes();
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.lightBlue),
            title: Text(
              'Lista descendente Apellido',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              setState(() {
                menu = 0;
                parametro = 'apellido';
                refrescarListaEstudiantes();
              });
            },
          ),
        ],
      ),
    );
  }

  //genera la tabla con lista de estudiantes
  SingleChildScrollView generarLista(List<Estudiante> estudiantes) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columnSpacing: 45,
          headingRowHeight: 30,
          columns: [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Apellido')),
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Eliminar'))
          ],
          rows: estudiantes
              .map((estudiante) => DataRow(cells: [
                    DataCell(Text(estudiante.id.toString())),
                    DataCell(Text(estudiante.apellido), onTap: () {
                      setState(() {
                        isUpdate = true;
                        estudianteIdForUpdate = estudiante.id;
                      });
                      _nombreController.text = estudiante.nombre;
                      _apellidoController.text = estudiante.apellido;
                      _correoController.text = estudiante.correo;
                      _celularController.text = estudiante.celular;
                      fechaController.text = estudiante.fecha;
                      _becado = estudiante.becado;
                      _genero = estudiante.genero;
                    }),
                    DataCell(Text(estudiante.fecha), onTap: () {
                      setState(() {
                        isUpdate = true;
                        estudianteIdForUpdate = estudiante.id;
                      });
                      _nombreController.text = estudiante.nombre;
                      _apellidoController.text = estudiante.nombre;
                      _correoController.text = estudiante.correo;
                      _celularController.text = estudiante.celular;
                      fechaController.text = estudiante.fecha;
                      _becado = estudiante.becado;
                      _genero = estudiante.genero;
                    }),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        estudianteHelper.eliminarEstudiante(estudiante.id);
                        refrescarListaEstudiantes();
                      },
                    ))
                  ]))
              .toList(),
        ),
      ),
    );
  }

void showToast(String msg, {int duracion, int gravedad}) {
    Toast.show(msg, context, duration: duracion, gravity: gravedad);
  }
  
  //Muestra el appBar
  _appBar() {
    return AppBar(
      title: Text(
        'Modulos del Sistema',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
