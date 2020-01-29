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


}