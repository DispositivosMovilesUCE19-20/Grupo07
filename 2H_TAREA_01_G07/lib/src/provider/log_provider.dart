import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:app_completa2/modelo/log.dart';

class LogProvider{

  final String _url = "https://optativa-log.firebaseio.com";

  Future<bool> crearLog(LogModel log) async{
    final url = '$_url/log.json';
    final response = await http.post(url, body: logModelToJson(log));

    final decodeData = json.decode(response.body);

    print(decodeData);

    return true;

  }


}