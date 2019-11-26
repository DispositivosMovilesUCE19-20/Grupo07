import 'package:flutter/material.dart';
import 'package:proyecto_final_g07/controlador/DBHelper.dart';
import 'package:proyecto_final_g07/modelo/Mensaje.dart';
import 'package:proyecto_final_g07/modelo/User.dart';
import 'package:proyecto_final_g07/rest/mensaje_provider.dart';
import 'package:proyecto_final_g07/vista/listadoUsuarios.dart';
import 'package:toast/toast.dart';


class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MostrarLogin(),
    );
  }
}

class MostrarLogin extends StatefulWidget {
  @override
  _MostrarLoginState createState() => _MostrarLoginState();
}

class _MostrarLoginState extends State<MostrarLogin> {
  final formkey = new GlobalKey<FormState>();
  final dbHelper = DBHelper();
  String _user, _pass;
  Future<List<User>> user;
  Future<User> user1;

  void moveToRegister() {
    Navigator.of(context).pushNamed('/RegistrarUsuario');
  }

  void moveToList() {
    Navigator.of(context).pushNamed('/listadoUsuarios');
  }

  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  Mensaje aux, auxMensaje;
  String mensajeText, mensajeTextU;
  Future<int> resul;
  Future<List<User>> students;
  List<User> userL;
  final String url = "servicioExamen";
  String a = "a";

  @override
  void initState() {
    super.initState();
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          aux = new Mensaje(lisMensaje[0].msg);
          mensajeText = aux.msg.toString();
        });
      }
    });
    //*****************************************************************
    lista = mensajeProvider.mensajeImprimir(url);
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          auxMensaje = new Mensaje(lisMensaje[0].msg);
          mensajeTextU = auxMensaje.msg.toString();
        });
      }
    });
    //*****************************************************************

  }


  @override
  Widget build(BuildContext context) {
    final buttom = new InkWell(
      child: new Container(
        margin: new EdgeInsets.only(top: 30.0, left: 20.0, right: 20),
        padding: EdgeInsets.all(10.0),
        height: 450,
        width: 280.0,
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Color(0xFFf38b02),
              offset: new Offset(10.0, 10.0),
              blurRadius: 30.0,
            )
          ],
          borderRadius: new BorderRadius.circular(30.0),
          color: Color(0xFFfeb800),
        ),
        child: new Form(
          key: formkey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.only(top: 0.0, left: 80.0, right: 80),
                padding: EdgeInsets.all(00.0),
                height: 100,
                width: 100.0,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(200),
                  color: Colors.blueGrey[100],
                ),
                child: ImagenCargar(),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.supervised_user_circle),
                    labelText: 'Ingrese su usuario'),
                validator: (value) =>
                    value.isEmpty ? 'Ingrese el usuario.' : null,
                onSaved: (value) => _user = value,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: 'Ingrese su contraseña'),
                obscureText: true,
                validator: (value) =>
                    value.isEmpty ? 'Ingrese la contraseña.' : null,
                onSaved: (value) => _pass = value,
              ),
              new Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: new RaisedButton(
                  child: new Text(
                    'Login',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  onPressed: () {
                    if (formkey.currentState.validate()) {
                      formkey.currentState.save();
                      user = dbHelper.getUser(_user, _pass);
                      dbHelper.getUser(_user, _pass).then((List<User> users) {
                        if (users != null && users.length > 0) {
                          formkey.currentState.reset();
                          Toast.show(
                              mensajeTextU,
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          Navigator.of(context).pushNamed('/listadoUsuarios');
                        } else {
                          Toast.show(
                              "El usuario o contraseña están incorrectas, ingrese otra vez.",
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      });
                    }
                  },
                  color: Colors.amber[800],
                ),
              ),
              new FlatButton(
                child: new Text(
                  'Crear una cuenta',
                  style: new TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                onPressed: moveToRegister,
              )
            ],
          ),
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.amber[300],
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new SingleChildScrollView(
                  child: new Container(
                alignment: Alignment.center,
                margin: new EdgeInsets.only(top: 30.0),
                child: new Column(
                  children: <Widget>[
                    if (mensajeText == null)
                      CircularProgressIndicator()
                    else
                      Text(
                        "${mensajeText}", // ignore: unnecessary_brace_in_string_interps
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF2196F3),
                            fontWeight: FontWeight.w600),
                      ),


                    new Text(
                      "Login",
                      style: const TextStyle(
                          fontSize: 55.0,
                          color: Color(0xFFFF8F00),
                          fontWeight: FontWeight.w600),
                    ),

                    // texto(),
                    buttom,
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class ImagenCargar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imagen = new AssetImage('assets/user2.png');
    var img = new Image(
      image: imagen,
      width: 90.0,
      height: 90.0,
    );
    return new Container(
      child: img,
    );
  }
}
