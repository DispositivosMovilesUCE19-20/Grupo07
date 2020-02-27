import 'package:app_completa5/scr/conexionDb/crud/CrudEstudiante.dart';
import 'package:app_completa5/scr/modelo/Estudiante.dart';
import 'package:app_completa5/scr/servicio/MensajeServicio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class CrearEstudiantePage extends StatefulWidget {
  @override
  _CrearEstudiantePageState createState() => _CrearEstudiantePageState();
}

class _CrearEstudiantePageState extends State<CrearEstudiantePage> {
  //Variable de estado del formulario
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  //Varriables para el registro
  String _nombre;
  String _apellido;
  String _correo;
  String _celular;
  int _genero;
  String _fecha;
  int _becado = 0;
  //Variable bandera para saber si se actualiza un registro
  int estudianteIdForUpdate;
  //Variable para cambiar el nombre de los botones
  bool isUpdate = false;
  //Variable lista de estudiantes
  Future<List<Estudiante>> estudiantes;
  //Instancia de los metodos crud
  CrudEstudiante crudEstudiante;
  //Variables controller
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _celularController = TextEditingController();
  final _generoController = TextEditingController();
  final _fechaController = TextEditingController();
  final _becadoController = TextEditingController();

  //formato de fecha
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
        _fechaController.text = formateador(_date);
        print(_date.toString());
      });
    }
  }

  String formateador(DateTime now) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    print(formatted); // something like 2013-04-20
    return formatted;
  }
  
  //Variable para ver como muestra mi lista
  int menu = 1;
  String parametro = 'fecha';
  String parametro2 = 'apellido';

  //Método de inicializacion
  @override
  void initState() {
    super.initState();
    crudEstudiante = CrudEstudiante();
    refrescarListaEstudiantes();
    obtenerMensajeEliminado();
  }

  refrescarListaEstudiantes() {
    setState(() {
      estudiantes = crudEstudiante.obtenerTodos(menu, parametro, parametro2);
    });
  }

  enviarCorreo(
    String correo, String nombre, String apellido, String celular) async {
    String username = 'jmorocho35@gmail.com';
    String password = 'jmdjmix0218';

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = new Message()
      ..from = new Address(username, 'Your name')
      ..recipients.add(correo)
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(new Address('bccAddress@example.com'))
      ..subject = 'Ingreso Satisfactorio'
      ..text = 'Hola $nombre $apellido , su celular es: $celular'
      ..html =
          "<h1>Hola $nombre $apellido , su celular es: $celular</h1>\n<p>Hey! Here's some HTML content</p>";

    final sendReports = await send(message, smtpServer);
    print('Se ha enviado el Mensaje');
  }

  //Consumo del servicio de endpoint con los mensajes
  final mensajeServicio = new MensajeServicio();

  Future<String> obtenerMensajeServicio() async {
    String mensaje = await mensajeServicio.getData('mensajeGrupo07');
    return mensaje;
  }

  //Varible y metodo para poner en el toast al eliminar
  String mensajeToast;
  Future<String> obtenerMensajeEliminado() async {
    String mensaje = await mensajeServicio.getData('mensajeEliminado');
    mensajeToast = mensaje;
    return mensaje;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                          _textFieldApellido(),
                          _textFieldCorreo(),
                          _textFieldCelular(),
                          _radioButtonGenero(),
                          _textFieldFecha(),
                          IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: () {
                                  selectDate();
                                }),
                          _switchBecado()
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _botonRegistrar(),
                        Padding(padding: EdgeInsets.all(10.0)),
                        _botonCancelar()
                      ],
                    )
                  ],
                )
              ],
            )),
            Divider(
              height: 50.0,
            ),
            _listarEstudiantes()
          ],
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      //leading: IconButton(
      //  padding: EdgeInsets.all(5.0),
      //  icon: Icon(Icons.arrow_back),
      //  color: Colors.white,
      //  onPressed: () {
      //    Navigator.pop(context);
      //  },
      //),
      title: Text(
        'Registro de Estudiantes',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  //Textfiel del nombre
  _textFieldNombre() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
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
  _textFieldApellido() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
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
        keyboardType: TextInputType.emailAddress,
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
  _textFieldCelular() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
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

  _textFieldFecha() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        //keyboardType: TextInputType.datetime,
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese la fecha';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _fecha = value;
        },
        controller: _fechaController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Fecha',
            icon: Icon(
              Icons.date_range,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

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
            crudEstudiante
                .actualizarEstudiante(Estudiante(estudianteIdForUpdate, _nombre,
                    _apellido, _correo, _celular, _genero, _fecha, _becado))
                .then((data) {
              setState(() {
                isUpdate = false;
              });
            });
          }
        } else {
          if (_formStateKey.currentState.validate()) {
            _formStateKey.currentState.save();
            crudEstudiante.crearEstudiante(Estudiante(null, _nombre, _apellido,
                _correo, _celular, _genero, _fecha, _becado));
                //enviarCorreo(_correo, _nombre, _apellido, _celular);
          }
        }
        _nombreController.text = '';
        _apellidoController.text = '';
        _correoController.text = '';
        _celularController.text = '';
        _fechaController.text = '';
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
        _fechaController.text = '';
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
            DataColumn(label: Text('Fecha')),
            DataColumn(label: Text('Apellido')),
            DataColumn(label: Text('Eliminar'))
          ],
          rows: estudiantes
              .map((estudiante) => DataRow(cells: [
                    DataCell(Text(estudiante.id.toString())),
                    DataCell(Text(estudiante.fechaNacimiento), onTap: () {
                      if (estudiante.becado == 0) {
                        setState(() {
                          isUpdate = true;
                          estudianteIdForUpdate = estudiante.id;
                        });
                        _nombreController.text = estudiante.nombre;
                        _apellidoController.text = estudiante.apellido;
                        _correoController.text = estudiante.correo;
                        _celularController.text = estudiante.celular;
                        _fechaController.text = estudiante.fechaNacimiento;
                        _becado = estudiante.becado;
                        _genero = estudiante.genero;
                        print(_becado);
                      } else {
                        showToast("El Estudiante es becado, no se edita",
                            duracion: Toast.LENGTH_LONG, gravedad: Toast.TOP);
                      }
                    }),
                    DataCell(Text(estudiante.apellido), onTap: () {
                      if (estudiante.becado == 0) {
                        setState(() {
                          isUpdate = true;
                          estudianteIdForUpdate = estudiante.id;
                        });
                        _nombreController.text = estudiante.nombre;
                        _apellidoController.text = estudiante.apellido;
                        _correoController.text = estudiante.correo;
                        _celularController.text = estudiante.celular;
                        _fechaController.text = estudiante.fechaNacimiento;
                        _becado = estudiante.becado;
                        _genero = estudiante.genero;
                        print(_becado);
                      } else {
                        showToast("El Estudiante es becado, no se edita",
                            duracion: Toast.LENGTH_LONG, gravedad: Toast.TOP);
                      }
                    }),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        if (estudiante.becado == 0) {
                          crudEstudiante.eliminarEstudiante(estudiante.id);
                          refrescarListaEstudiantes();
                          showToast(mensajeToast,
                              duracion: Toast.LENGTH_LONG, gravedad: Toast.TOP);
                        } else {
                          showToast("El Estudiante es becado, no se elimino",
                              duracion: Toast.LENGTH_LONG, gravedad: Toast.TOP);
                        }
                      },
                    ))
                  ]))
              .toList(),
        ),
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
          ListTile(
            leading: Icon(Icons.lock, color: Colors.lightBlue),
            title: Text(
              'Lista descendente 2 parametros',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              setState(() {
                menu = 0;
                parametro = 'apellido';
                parametro2 = 'fecha';
                refrescarListaEstudiantes();
              });
            },
          ),
        ],
      ),
    );
  }

  void showToast(String msg, {int duracion, int gravedad}) {
    Toast.show(msg, context, duration: duracion, gravity: gravedad);
  }
}
