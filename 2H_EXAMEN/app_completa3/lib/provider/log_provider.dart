import 'dart:convert';

import 'package:app_completa3/modelo/log.dart';
import 'package:http/http.dart' as http;



class LogProvider{

  final String _url = "https://optativa-log-cd9e6.firebaseio.com";

  Future<bool> crearLog(LogModel log) async{
    final url = '$_url/log.json';
    final response = await http.post(url, body: logModelToJson(log));
    final decodeData = json.decode(response.body);
    print(decodeData);
    return true;
  }

  //Listo los mensajes
  Future<List<LogModel>> getData() async{
    final url = 'https://optativa-log-cd9e6.firebaseio.com/log/-LyX9ZnI-DgBRN_NYYOH.json';
    http.Response res = await http.get(
      Uri.encodeFull(url),
      headers: {
        "Accept": "application/json"
      }
    );
    final decode =await json.decode(res.body);
    print(decode);
    final mensaje = new Logs.fromJsonList(decode);
    print('Desde el firebase *****');
    //print(mensaje.lista[0].usuario);
    return mensaje.lista;
  }


}