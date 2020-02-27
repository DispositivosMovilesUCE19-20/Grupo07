import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificatioLocal {
  /* *********************************************  NOTIFICACIONES LOCALES   ******************************** */

  
  final String serverToken =
      'AAAARe_ImH4:APA91bGlKJsgyCTd-MgyjZdukhaxHhgFzObI9_wRXA497mi23JQsk1fd5BZezcm5d1LZxJbvrmB-Xel_9SZgy-IWwOFCd8lD0-MscxgUJ7ZtiYNow7Dlmfk_Fuw89oDkp-QEII7VcGf-';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendAndRetrieveMessage( String mensaje ) async {
    
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

  print(firebaseMessaging.getToken());
  print(mensaje);
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': mensaje,
            'title': 'Notificación'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
  /* *********************************************  NOTIFICACIONES LOCALES   ******************************** */

}
