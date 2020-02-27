import 'dart:io';

import 'package:app_completa5/scr/conexionDb/crud/CrudUsuario.dart';
import 'package:app_completa5/scr/modelo/Log.dart';
import 'package:app_completa5/scr/modelo/Usuario.dart';
import 'package:app_completa5/scr/preferencias/PreferenciaUsuario.dart';
import 'package:app_completa5/scr/servicio/LogServicio.dart';
import 'package:app_completa5/scr/servicio/MensajeServicio.dart';
import 'package:app_completa5/scr/utilidades/logo.dart';
import 'package:app_completa5/scr/vistas/usuario/CrearUsuario.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:light/light.dart';
import 'package:proximity_plugin/proximity_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:toast/toast.dart';

import 'dart:async';

import 'InicioPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

  static Route<dynamic> route() {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  //para el sensor de proximidad
  String _proximity;
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  //Para el brillo
  bool _brilloTema;
  final prefs = new PreferenciaUsuario();
  //Variable para guardar en Firebase
  final logProvider = new LogProvider();
  Log log = new Log();
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
  CrudUsuario crudUsuario;
  //Variables para el sensor de luz
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
    crudUsuario = CrudUsuario();
    _brilloTema = prefs.colorSecundario;
    initPlatformState();
    initSpeechRecognizer();
  }

  //Reconocimiento por voz
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  Future<void> initPlatformState() async {
    startListening();
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        _proximity = event.x;
      });
    }));
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription.cancel();
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  //Consumo del servicio desde el endpoint
  final mensajeServicio = new MensajeServicio();
  //Metodo para obtener el mensaje de acuerdo al edpoint
  Future<String> obtenerMensajeServicio() async {
    String mensaje = await mensajeServicio.getData('mensajeGrupo07');
    return mensaje;
  }

  //Brillo de la pantalla
  Brightness brightness = Brightness.light;
  int cont = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _logueado ? InicioPage() : loginForm(),
    );
  }

  LogProvider logServicio = new LogProvider();
  String fecMos;
  Future<String> obteneFecha() async {
    String mensaje = await logServicio.getFechas();
    print(mensaje);
    fecMos = mensaje;
    return mensaje;
  }

  loginForm() {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          //Muestra el mensaje del servicio consumido
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
          Center(
            child: FutureBuilder<String>(
              future: obteneFecha(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          SizedBox(
            height: 90.0,
          ),
          Column(
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
                    Switch(
                      value: _brilloTema,
                      onChanged: (value) {
                        _brilloTema = value;
                        prefs.colorSecundario = value;
                        setState(() {});
                      },
                    ),
                    Text('Sensor de luz: $_luxString\n'),
                    Text('Posición : $_pos\n'),
                    Text('Metros de punto1: $_distanceInMeters\n'),
                    Text('Metros de punto2: $_distanceInMeters\n'),
                    Text('Sensor de proximidad: $_proximity\n'),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FloatingActionButton(
                                heroTag: "btn1",
                                child: Icon(Icons.cancel),
                                mini: true,
                                backgroundColor: Colors.deepOrange,
                                onPressed: () {
                                  if (_isListening)
                                    _speechRecognition.cancel().then(
                                          (result) => setState(() {
                                            _isListening = result;
                                            resultText = "";
                                          }),
                                        );
                                },
                              ),
                              FloatingActionButton(
                                heroTag: "btn2",
                                child: Icon(Icons.mic),
                                onPressed: () {
                                  if (_isAvailable && !_isListening)
                                    _speechRecognition
                                        .listen(locale: "en_US")
                                        .then((result) => print('$result'));
                                },
                                backgroundColor: Colors.pink,
                              ),
                              FloatingActionButton(
                                heroTag: "btn3",
                                child: Icon(Icons.stop),
                                mini: true,
                                backgroundColor: Colors.deepPurple,
                                onPressed: () {
                                  if (_isListening)
                                    _speechRecognition.stop().then(
                                          (result) => setState(
                                              () => _isListening = result),
                                        );
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent[100],
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            child: Text(
                              resultText,
                              style: TextStyle(fontSize: 24.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      height: 20.0,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.record_voice_over,
                          size: 42.0,
                          color: Colors.lightBlue,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          if (resultText == 'Hola') {
                            if (Platform.isAndroid) {
                              log.dispositivo = 'Android';
                              log.acceso = 'Login';
                              var now = new DateTime.now();
                              log.fecha = now.toString();
                              prefs.setString("usuario", _usuario);
                              prefs.setString("clave", _clave);
                              logProvider.crearLog(log);
                            }

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
                        }),
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
                        ),
                      ),
                      onSaved: (text) {
                        _usuario = text;
                        log.usuario = text;
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty) {
                          return 'Ingrese su clave';
                        }
                        if (text.trim() == "") {
                          return 'El campo es requerido';
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
                        icon: Icon(
                          Icons.arrow_forward,
                          size: 42.0,
                          color: Colors.lightBlue,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            crudUsuario
                                .getUsuario(_usuario, _clave)
                                .then((Usuario usuario) {
                              if (usuario != null || resultText == 'Hola') {
                                if (Platform.isAndroid && usuario != null) {
                                  log.id = usuario.id;
                                  log.dispositivo = 'Android';
                                  log.acceso = 'Login';
                                  var now = new DateTime.now();
                                  log.fecha = now.toString();
                                  prefs.setString("usuario", _usuario);
                                  prefs.setString("clave", _clave);
                                  logProvider.crearLog(log);
                                }

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
                        }),
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
                )),
          )
        ],
      ),
    );
  }

  void showToast(String msg, {int duracion, int gravedad}) {
    Toast.show(msg, context, duration: duracion, gravity: gravedad);
  }
}
