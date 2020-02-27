import 'package:app_completa5/scr/modelo/Mensaje.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MensajeServicio{
  //Url
  String _url = "https://restapimensaje.herokuapp.com/";
  //Listo el mensaje
  Future<String> getData(String endPoint) async{
    String url = '$_url$endPoint';
    http.Response res = await http.get(Uri.encodeFull(url),
    headers: {
      "Accept": "application/json"
    });
    final decode = await json.decode(res.body);
    final mensaje = Mensajes.fromJsonList(decode);
    //print('El mensaje es: ');
    //print(mensaje.lista[0].msg);
    return mensaje.lista[0].msg;
  }
}