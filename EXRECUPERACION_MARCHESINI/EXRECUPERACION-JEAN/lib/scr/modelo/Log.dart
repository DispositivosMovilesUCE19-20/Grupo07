import 'dart:convert';

Log logModelFromJson(String str) => Log.fromJson(json.decode(str));

String logModelToJson(Log data) => json.encode(data.toJson());

//Clase para obtener la información desde firebase
class Logs{
  List<Log> lista = new List();
  Logs();
  Logs.fromJsonList(List<dynamic> jsonList){
    if(json == null) return;
    for(var item in jsonList){
      final res = new Log.fromJson(item);
      print(res);
      lista.add(res);
    }
  }
}

//Clase log para persistir en sqlite y firebase
class Log{

  int id;
  String usuario;
  String clave;
  String dispositivo;
  String acceso;
  String fecha;

  //Logica para persistencia en sqflite
    Map<String, dynamic> toMap(){
      var map = <String, dynamic> {
        'id'          : id,
        'usuario'     : usuario,
        'clave'       : clave,
        'dispositivo' : dispositivo,
        'acceso'      : acceso,
        'fecha'       : fecha
      };
      return map;
    }

    Log.fromMap(Map<String, dynamic> map){
      acceso      = map['acceso'];
      clave       = map['clave'];
      dispositivo = map['dispositivo'];
      fecha       = map['fecha'];
      usuario     = map['usuario'];
      id          = map['id'];
    }

    //Logica para la persistencia en Firebase
    Log({
        this.id,
        this.usuario,
        this.clave,
        this.dispositivo,
        this.acceso,
        this.fecha,
    });

    factory Log.fromJson(Map<dynamic, dynamic> json) => Log(
        id            : json["clave"],
        acceso        : json["acceso"],
        clave         : json["clave"],
        dispositivo   : json["dispositivo"],
        fecha         : json["fecha"], 
        usuario       : json["usuario"]
    );

    Map<String, dynamic> toJson() => {
        "id"          : id,
        "usuario"     : usuario,
        "clave"       : clave,
        "dispositivo" : dispositivo,
        "acceso"      : acceso,
        "fecha"       : fecha,
    };

}