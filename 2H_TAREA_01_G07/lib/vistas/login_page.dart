import 'dart:io';

import 'package:app_completa2/dbHelper/dbHelper.dart';
import 'package:app_completa2/modelo/log.dart';
import 'package:app_completa2/modelo/usuario.dart';
import 'package:app_completa2/src/provider/log_provider.dart';
import 'package:app_completa2/vistas/inicio_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => LoginPage(),
    );
  }

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

      
  
  //para el firebase
  final logProvider = new LogProvider();

  AnimationController controller;
  Animation<double> animation;

  GlobalKey<FormState> _key = GlobalKey();
  LogModel log = new LogModel();

  String _usuario = '';
  String _clave = '';
  bool _logueado = false;
  List<Future<Usuario>> usrTemp;

  DBHelper dbHelper;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    dbHelper = DBHelper();
    
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: _logueado ? InicioPage() : loginForm(),
    );
  }

  loginForm() {
    
    return SafeArea(
      child: ListView(children: <Widget>[
        SizedBox(
          height: 90.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedLogo(animation: animation),
              ],
            ),
            Container(
              width: 300.0,
              child: Form(
                key: _key,
                //autovalidate: true,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'Ingrese su usuario';
                        }
                        if (text.trim() == "") {
                          return 'Este campo es requerido';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Ingrese su usuario',
                          labelText: 'Usuario',
                          icon: Icon(
                            Icons.person,
                            color: Colors.lightBlue,
                            size: 32.0,
                          )),
                      onSaved: (text) {
                        log.usuario = text;
                        _usuario = text;
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'Ingrese su clave';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Ingrese su clave',
                          labelText: 'Clave',
                          icon: Icon(
                            Icons.lock,
                            size: 32.0,
                            color: Colors.lightBlue,
                          )),
                      onSaved: (text) {
                        _clave = text;
                        log.clave = text;
                      },
                    ),
                    IconButton(
                      onPressed: () async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        
                        if (_key.currentState.validate()) {
                          _key.currentState.save();
                          //Verifica usuario con BD
                          dbHelper
                              .getUsuario(_usuario, _clave)
                              .then((List<Usuario> usuarios) {
                            if (usuarios != null && usuarios.length > 0) {
                              if (Platform.isAndroid) {
                                log.dispositivo = 'Android';
                                log.acceso = 'Login';
                                var now = new DateTime.now();
                                //print(now);
                                log.fecha = now.toString();
                                prefs.setString("usuario", _usuario);
                                prefs.setString("clave", _clave);
                              }
                              logProvider.crearLog(log);

                              setState(() {
                                _logueado = true;
                              });
                              showToast("Bienvenido al Sistema",
                                  duracion: Toast.LENGTH_LONG,
                                  gravedad: Toast.BOTTOM);
                            } else {
                              print('Intenta de nuevo');
                              showToast("Credenciales Incorrectas",
                                  duracion: Toast.LENGTH_LONG,
                                  gravedad: Toast.TOP);
                            }
                          });
                        }
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        size: 42.0,
                        color: Colors.lightBlue,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  void showToast(String msg, {int duracion, int gravedad}) {
    Toast.show(msg, context, duration: duracion, gravity: gravedad);
  }
}

class AnimatedLogo extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 150.0);

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: _sizeTween.evaluate(animation), // Aumenta la altura
        width: _sizeTween.evaluate(animation), // Aumenta el ancho
        child: FlutterLogo(),
      ),
    );
  }
}
