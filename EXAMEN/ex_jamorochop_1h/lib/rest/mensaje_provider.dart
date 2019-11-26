import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:proyecto_final_g07/modelo/Mensaje.dart';





class MensajeProvider{

  //Metodo para procesar el json

  //Listo los mensajes
  Future<List<Mensaje>> getData() async{
    http.Response res = await http.get(
        Uri.encodeFull("https://restapimensaje.herokuapp.com/mensajeGrupo07"),
        headers: {
          "Accept": "application/json"
        }
    );
    final decode =await json.decode(res.body);
    //print(decode);
    final mensaje = new Mensajes.fromJsonList(decode);
    print(mensaje.lista[0].msg);
    return mensaje.lista;
  }

  //mensaje para eliminar
  Future<List<Mensaje>> mensajeImprimir(String url) async{
    http.Response res = await http.get(
        Uri.encodeFull("https://restapimensaje.herokuapp.com/"+url),
        headers: {
          "Accept": "application/json"
        }
    );
    final decode =await json.decode(res.body);
    //print(decode);
    final mensaje = new Mensajes.fromJsonList(decode);
    return mensaje.lista;
  }

  Future<List<Mensaje>> lista;
  Mensaje auxMensaje, auxMensajeE, auxMensajeEE;
  String mensajeText, mensajeTextE, mensajeTextEE;
  final String url = "mensajeEliminado";
  final String urlE = "mensajeErrorEliminado";

  Future<String> obtenerMensaje(String url) async{
    lista = this.mensajeImprimir(url);
    print(lista.toString());
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
          auxMensajeE = new Mensaje(lisMensaje[0].msg);
          mensajeTextE = auxMensajeE.msg.toString();
          print(mensajeTextE);
      } else{
        print("no etra al if");
      }

    });
    return mensajeTextE;
  }

}