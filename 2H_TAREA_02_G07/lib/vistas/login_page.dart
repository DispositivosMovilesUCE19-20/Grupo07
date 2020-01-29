import 'dart:async';
import 'dart:io';

import 'package:app_completa3/dbHelper/crud/crud_usuario.dart';
import 'package:app_completa3/modelo/log.dart';
import 'package:app_completa3/modelo/usuario.dart';
import 'package:app_completa3/provider/log_provider.dart';
import 'package:app_completa3/utilidades/logo.dart';
import 'package:app_completa3/vistas/inicio_page.dart';
import 'package:app_completa3/vistas/usuario/create_usuario_page.dart';
import 'package:app_completa3/vistas/usuario/usuario_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:light/light.dart';
import 'package:geolocator/geolocator.dart';

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
  LogModel log = new LogModel();
  //Variables para el logo
  AnimationController controller;
  Animation<double> animation;
  //Variable de estado del formulario
  GlobalKey<FormState> _key = GlobalKey();
  //variables para el login del usuario
  String _usuario;
  String _clave;
  //Variable para verificar el acceso
  bool _logueado = false;
  //Lista de usuarios
  List<Future<Usuario>> usrTemp;
  //instancia del crud
  CRUDUsuario usuarioHelper;
  String _luxString = 'Unknown';
  String _pos;
  double _distanceInMeters;
  double _distanceInMetersPunto2;
  Light _light;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    usuarioHelper = CRUDUsuario();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("positicion : $position");
    double distanceInMeters = await Geolocator().distanceBetween(
        -0.198465, -78.503067, position.latitude, position.longitude);
    double distanceInMeters2 = await Geolocator().distanceBetween(
        -0.198697, -78.503267, position.latitude, position.longitude);
    print("meros : $distanceInMeters");
    setState(() {
      _luxString = "$luxValue";
      _pos = "$position";
      _distanceInMeters = distanceInMeters;
      _distanceInMetersPunto2 = distanceInMeters2;
    });
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _logueado ? InicioPage() : loginForm(),
    );
  }

  loginForm() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 90.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedLogo(
                    animation: animation,
                  )
                ],
              ),
              Container(
                width: 300.0,
                child: Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Text('Sensor de luz: $_luxString\n'),
                      Text('Posición : $_pos\n'),
                      Text('Metros de punto1: $_distanceInMeters\n'),
                      Text('Metros de punto2: $_distanceInMeters\n'),
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
                          _usuario = text;
                          log.usuario = text;
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
                            hintText: 'Clave',
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
                        onPressed: () async {
                          //obtengo las preferencias de usuario
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            usuarioHelper
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
                      ),
                      Divider(
                        height: 20.0,
                      ),
                      InkWell(
                        child: Text('Crear Usuario'),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CrearUsuarioPage(),
                              ));
                        },
                      ),
                      Divider(
                        height: 20.0,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void showToast(String msg, {int duracion, int gravedad}) {
    Toast.show(msg, context, duration: duracion, gravity: gravedad);
  }
}
