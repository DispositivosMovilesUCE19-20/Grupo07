import 'dart:convert';

class Mensaje{
  String msg;

  Mensaje(this.msg);

  //Mapeo a json
  Mensaje.fromJsonMap(Map<String, dynamic> json){
    msg = json['msg'];
  }
}

//Clase que transforma en lista los mensajes recuperados
class Mensajes{
  List<Mensaje> lista = new List();
  Mensajes();
  Mensajes.fromJsonList(List<dynamic> jsonList){
    if(json == null) return;
    for(var item in jsonList){
      final mensaje = new Mensaje.fromJsonMap(item);
      lista.add(mensaje);
    }
  }
}