import 'dart:io';

import 'package:app_completa3/dbHelper/crud/crud_estudiante.dart';
import 'package:app_completa3/modelo/estudiante.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EstudiantePage extends StatefulWidget {
  @override
  _EstudiantePageState createState() => _EstudiantePageState();
}

class _EstudiantePageState extends State<EstudiantePage> {
  //Variable de estado del formulario
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  //Variables para el registro de un nuevo estudiante
  String _nombre;
  String _apellido;
  String _correo;
  String _celular;
  //variable para ver si se actualizo un registro
  int estudianteIdForUpdate;
  //Variable para cambiar el nombre de los botones
  bool isUpdate = false;
  //Variable lista de estudiantes
  Future<List<Estudiante>> estudiantes;
  //Instancia de los metodos crud
  CRUDEstudiante estudianteHelper;

  //metodo de inicializacion
  @override
  void initState() {
    super.initState();
    estudianteHelper = CRUDEstudiante();
    refrescarListaEstudiantes();
  }

  refrescarListaEstudiantes() {
    setState(() {
      estudiantes = estudianteHelper.getEstudiantes();
    });
  }

  //Variables controller
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _celularController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(),
      body: Container(
        child: Column(
          children: <Widget>[
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
                    _apellido, _correo, _celular))
                .then((data) {
              setState(() {
                isUpdate = false;
              });
            });
          }
        } else {
          if (_formStateKey.currentState.validate()) {
            _formStateKey.currentState.save();
            estudianteHelper.registrarEstudiante(
                Estudiante(null, _nombre, _apellido, _correo, _celular));
          }
        }
        _nombreController.text = '';
        _apellidoController.text = '';
        _correoController.text = '';
        _celularController.text = '';
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
            DataColumn(label: Text('Usuario')),
            DataColumn(label: Text('Clave')),
            DataColumn(label: Text('Eliminar'))
          ],
          rows: estudiantes
              .map((estudiante) => DataRow(cells: [
                    DataCell(Text(estudiante.id.toString())),
                    DataCell(Text(estudiante.nombre), onTap: () {
                      setState(() {
                        isUpdate = true;
                        estudianteIdForUpdate = estudiante.id;
                      });
                      _nombreController.text = estudiante.nombre;
                      _apellidoController.text = estudiante.apellido;
                      _correoController.text = estudiante.correo;
                      _celularController.text = estudiante.celular;
                    }),
                    DataCell(Text(estudiante.apellido), onTap: () {
                      setState(() {
                        isUpdate = true;
                        estudianteIdForUpdate = estudiante.id;
                      });
                      _nombreController.text = estudiante.nombre;
                      _apellidoController.text = estudiante.nombre;
                      _correoController.text = estudiante.correo;
                      _celularController.text = estudiante.celular;
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

  //Muestra el appBar
  Widget _appBar() {
    return AppBar(
      leading: IconButton(
        padding: EdgeInsets.all(5.0),
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        'Modulo de Estudiantes',
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
}
