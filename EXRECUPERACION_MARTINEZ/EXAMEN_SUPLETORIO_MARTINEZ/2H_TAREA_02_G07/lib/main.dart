
import 'package:app_completa3/preferencias/preferencias_usuario.dart';
import 'package:app_completa3/provider/push_notification_provider.dart';
import 'package:app_completa3/vistas/estudiante/estudiante_page.dart';
import 'package:app_completa3/vistas/inicio_page.dart';

import 'package:app_completa3/vistas/login_page.dart';
import 'package:app_completa3/vistas/usuario/create_usuario_page.dart';
import 'package:app_completa3/vistas/usuario/usuario_page.dart';
import 'package:flutter/material.dart';
 
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

  //Para la navegación con notificaciones
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

      navigatorKey.currentState.pushNamed('crearUsuario', arguments: data);
    });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //Para navegar el push
       navigatorKey: navigatorKey,//maneja el estado del mateapp a lo largo de la clase
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      initialRoute: 'login',
      routes: {
        'usuarios'    : (BuildContext context) => UsuarioPage(),
        'estudiantes' : (BuildContext context) => EstudiantePage(),
        'inicio'      : (BuildContext context) => InicioOage(),
        'login'       : (BuildContext context) => LoginPage(),
        'crearUsuario': (BuildContext context) => CrearUsuarioPage()
      },
    );
  }
}