
import 'dart:isolate';

import 'package:app_completa2/src/preferencias/preferencias_usuario.dart';
import 'package:app_completa2/src/provider/push_notification_provider.dart';
import 'package:app_completa2/vistas/login_page.dart';
import 'package:app_completa2/vistas/usuario_page.dart';
import 'package:flutter/material.dart';

//void isolate(String arg){
//  final prefs = new PreferenciaUsuario();
//  String usr = prefs.usuario;
//  String pass = prefs.clave;
//  print('En segundo plano recupero el usuario: ' + usr + ' ' + pass);
//}


void main() async{ 
  WidgetsFlutterBinding.ensureInitialized();

 
  final prefs = new PreferenciaUsuario();
  await prefs.initPrefs();
  //final isolateE = await Isolate.spawn(isolate, "Isolate 2");
  print('Preferencias');
  print(prefs.usuario);
  print(prefs.clave);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Para la navegación
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() { 
    super.initState();
    //Inicialiso el provider
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotificaciones();
    //escucho el stream del provider
    pushProvider.mensajes.listen((data){
      print('Argumento del Push');
      print(data);

      navigatorKey.currentState.pushNamed('usuario', arguments: data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'login',
      routes: {
        'login'  : (BuildContext context) => LoginPage(),
        'usuario': (BuildContext context) => UsuarioPage(),
      },
      navigatorKey: navigatorKey,//maneja el estado del mateapp a lo largo de la clase
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      primarySwatch: Colors.lightBlue,
      ),
      //home: LoginPage(),
      //home: InicioPage(),
      
    );
    
  }
}

