
import 'dart:convert';

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


class Mensaje {
  String msg;

  Mensaje(
    this.msg
  );

  //Mapeo del json
  Mensaje.fromJsonMap(Map<String, dynamic> json){
    msg = json['msg'];
  }

  getMensaje(){
    if (msg == null){
      return 'No hay Servicio';
    }else{
      return '$msg';
    }
  }

}