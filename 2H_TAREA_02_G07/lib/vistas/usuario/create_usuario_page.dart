import 'package:app_completa3/dbHelper/crud/crud_usuario.dart';
import 'package:app_completa3/modelo/usuario.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CrearUsuarioPage extends StatefulWidget {
  @override
  _CrearUsuarioPageState createState() => _CrearUsuarioPageState();
}

class _CrearUsuarioPageState extends State<CrearUsuarioPage> {
  //Variable de estado para el formulario
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  //Variables para el registro de un nuevo usuario
  String _usuario;
  String _clave;
  //variable para ver si se actualizo
  int usuarioIdForUpdate;
  //Variable para cambiar el label del boton de registrar
  bool isUpdate = false;
  //Lista de usuarios
  Future<List<Usuario>> usuarios;
  //Instancia de la base
  CRUDUsuario usuarioHelper;
  //metodo de inicialización
  @override
  void initState() {
    super.initState();
    usuarioHelper = CRUDUsuario();
  }

  //Variables controller
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //mostrar la notificacion
    final argumento = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: <Widget>[
          //Aqui el argmento de la notificación
          Form(
            key: _formStateKey,
            //autovalidate: true,
            child: Column(
              children: <Widget>[
                Text(argumento ?? ''),
                _textFieldUsuario(),
                _textFielClave(),
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
    );
  }

  //formulario de registro de usuario
  _textFieldUsuario() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese el usuario';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _usuario = value;
        },
        controller: _usuarioController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Usuario',
            icon: Icon(
              Icons.person,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.white,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

  //caja de texto para crear el usuario
  _textFielClave() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese la clave del usuario';
          }
          if (value.trim() == "") {
            return 'Espacio en blanco no es valido';
          }
          return null;
        },
        onSaved: (value) {
          _clave = value;
        },
        controller: _claveController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.lightBlue,
                    width: 2,
                    style: BorderStyle.solid)),
            labelText: 'Clave',
            icon: Icon(
              Icons.security,
              color: Colors.lightBlue,
            ),
            fillColor: Colors.lightBlue,
            labelStyle: TextStyle(color: Colors.lightBlue)),
      ),
    );
  }

  //Boton registrar
  _botonRegistrar() {
    return RaisedButton(
      color: Colors.lightBlue,
      child: Text(
        'Insertar',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (_formStateKey.currentState.validate()) {
          usuarioHelper
              .getUsuario(_usuario, _clave)
              .then((List<Usuario> usuarios) {
            if (usuarios != null && usuarios.length > 0) {
              setState(() {
                _formStateKey.currentState.save();
                usuarioHelper.registrarUsuario(Usuario(null, _usuario, _clave));
                showToast("Usuario Creado",
                    duracion: Toast.LENGTH_LONG, gravedad: Toast.CENTER);
              });
            } else {
              showToast("El Usuario no se creo o ya esta registrado",
                  duracion: Toast.LENGTH_LONG, gravedad: Toast.CENTER);
            }
          });
        }

        _usuarioController.text = '';
        _claveController.text = '';
      },
    );
  }

  //boton cancelar
  _botonCancelar() {
    return RaisedButton(
      color: Colors.lightBlue,
      child: Text(
        'Limpiar',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        _usuarioController.text = '';
        _claveController.text = '';
        setState(() {
          isUpdate = false;
          usuarioIdForUpdate = null;
        });
      },
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
        'Crear Usuario',
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 20.0),
          child: Icon(
            Icons.people,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  void showToast(String msg, {int duracion, int gravedad}) {
    Toast.show(msg, context, duration: duracion, gravity: gravedad);
  }
}
