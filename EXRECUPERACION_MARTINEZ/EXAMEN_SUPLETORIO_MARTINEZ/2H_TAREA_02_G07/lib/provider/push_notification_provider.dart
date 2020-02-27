import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'dart:io';

class PushNotificationProvider{

  
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //Cambiar de pagina cuando resive la notifiacion
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  initNotificaciones(){
    //pedir permisos a los usuarios e identificar tokens para identificar el dispositivo
    _firebaseMessaging.requestNotificationPermissions();
    //token del dispositivo
    _firebaseMessaging.getToken().then((token){
      print('===== Firebase Token ======');
      print(token);

      //era6Ra79_iw:APA91bGVi7EsBJfvb9CrbgxHorjAMcTvPY6v3qGmTQlyU1aGypuR9V_93_7fmsQ3zEty7q2aH7Z5AUgBo4WzETfgNuR_GIsaIM4cb_UqPH7Ls9KowkPuMycu_2NznWeCdUkgoH02_42U

    });
    //configuracion de los metodos
    _firebaseMessaging.configure(
      //cuando la aplicación esta abierta
      onMessage: (info) async{
        print('===== On Message =====');
        print(info);
        //Recupero campos de la notificación
        final notificacion = info['data']['Optativa'];
        print(notificacion);
        //ver si es ios o android
        String argumento = 'no-data';
        if(Platform.isAndroid){
          argumento = info['data']['Optativa'] ?? 'no-data';
        }
        _mensajesStreamController.sink.add(argumento);

      },
      onLaunch: (info) async{
        print('===== On Launch =====');
        print(info);
        //Recupero campos de la notificación
        final notificacion = info['data']['Optativa'];
        print(notificacion);
      },
      onResume: (info) async{
        print('===== On Resume =====');
        print(info);
        //Recupero campos de la notificación
        final notificacion = info['data']['Optativa'];
        print(notificacion);
        final noti = info['data']['Optativa'];
        //Linea descomentada da acceso al usuarioPage()
        _mensajesStreamController.sink.add(noti);
      },
    );
  }



  //Cierra el stream
  dispose(){
    _mensajesStreamController.close();
  }
}