import 'package:app_completa5/scr/preferencias/PreferenciaUsuario.dart';
import 'package:app_completa5/scr/servicio/PushNotifiction.dart';
import 'package:app_completa5/scr/vistas/usuario/CrearUsuario.dart';
import 'package:flutter/material.dart';

import 'scr/vistas/LoginPage.dart';
import 'scr/vistas/estudiante/CrearEstudiante.dart';


 
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Instancia para obtener las prefrencias e imprimirlos
  final prefs = new PreferenciaUsuario();
  await prefs.initPrefs();
  print('=== Datos de la preferencia ===');
  print(prefs.usuario);
  print(prefs.clave);
  print(prefs.colorSecundario);
  runApp(MyApp());
} 
 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final prefs = new PreferenciaUsuario();
  //Variable para la navegación a una vista desde una notificación 
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    //Instancio e Inicializo el servicio de las PushNotification
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotificaciones();
    //Escucha el stream del servicio para obtener el cuerpo de la notificación
    pushProvider.mensajes.listen((data){
      print('=== Argumento de la notificación ===');
      print(data);
      //Navego a otra página
      navigatorKey.currentState.pushNamed('crearUsuario', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Key para navegar cuando llegue la notificación
      navigatorKey: navigatorKey,//maneja el estado del mateapp a lo largo de la clase
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        brightness:  (prefs.colorSecundario)? Brightness.dark : Brightness.light,
        
      ),
      initialRoute: 'login',
      routes: {
        'login'             : (BuildContext context) => LoginPage(),
        'crearEstudiantes'  : (BuildContext context) => CrearEstudiantePage(),
        'crearUsuario'      : (BuildContext context) => CrearUsuarioPage(),
      },
      
    );
  }
}