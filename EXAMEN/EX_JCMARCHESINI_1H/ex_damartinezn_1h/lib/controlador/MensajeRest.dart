
import 'package:proyecto_final_g07/modelo/Mensaje.dart';
import 'package:proyecto_final_g07/rest/mensaje_provider.dart';

class MensajeRest{
  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  Mensaje aux;
  String mensajeText;

  String mensajeEnviar(){
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje){
      if(lisMensaje != null && lisMensaje.length>0){
          aux = new Mensaje(lisMensaje[0].msg);
          mensajeText = aux.msg.toString();
      }
    });
    return aux.msg;
  }

}