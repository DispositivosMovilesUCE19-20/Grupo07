import 'dart:io';

import 'package:app_completa5/scr/modelo/Log.dart';
import 'package:app_completa5/scr/preferencias/PreferenciaUsuario.dart';
import 'package:app_completa5/scr/servicio/LogServicio.dart';
import 'package:app_completa5/scr/servicio/MensajeServicio.dart';
import 'package:app_completa5/scr/vistas/estudiante/CrearEstudiante.dart';
import 'package:app_completa5/scr/vistas/usuario/UsuarioPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_extended/flutter_local_notifications_extended.dart';

import 'LoginPage.dart';

class InicioPage extends StatefulWidget {
  //Para las notificaciones locales
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final logProvider = new LogProvider();

  Log log = new Log();

  final prefs = new PreferenciaUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      drawer: _drawer(context),
      body: _body(context),
    );
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    _showNotificationWithoutSound();
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
      'Bienvenido a la vista Usuarios',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

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
              'Cerrar Sesion',
              style: TextStyle(fontSize: 20.0),
            ),
            onTap: () {
              Navigator.push(context, LoginPage.route());
              if (Platform.isAndroid) {
                log.acceso = 'Logout';
                log.dispositivo = 'Android';
                var now = new DateTime.now();
                log.fecha = now.toString();
              }
              log.usuario = prefs.usuario;
              log.clave = prefs.clave;
              logProvider.crearLog(log);
            },
          )
        ],
      ),
    );
  }

  final mensajeServicio = new MensajeServicio();

  Future<String> obtenerMensajeServicio() async {
    String mensaje = await mensajeServicio.getData('mensajeGrupo07');
    return mensaje;
  }

  _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          //Msstramos el mensaje del servicio en un future builder dentro del center
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
          SizedBox(
            height: 50.0,
          ),
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Usuarios',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UsuarioPage()));
              },
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          SizedBox(
            width: 100.0,
            height: 50.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Estudiantes',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CrearEstudiantePage()));
              },
            ),
          )
        ],
      ),
    );
  }
}
