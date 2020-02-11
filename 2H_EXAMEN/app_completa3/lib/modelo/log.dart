import 'dart:convert';

LogModel logModelFromJson(String str) => LogModel.fromJson(json.decode(str));

String logModelToJson(LogModel data) => json.encode(data.toJson());

class Logs{
  List<LogModel> lista = new List();
  Logs();
  Logs.fromJsonList(List<dynamic> jsonList){
    if(json == null) return;
    for(var item in jsonList){
      final mensaje = new LogModel.fromJson(item);
      lista.add(mensaje);
      print(lista.length.toString());
    }
  }
}

class LogModel {

    int id;
    String usuario;
    String clave;
    String dispositivo;
    String acceso;
    String fecha;

    

    //Logica para guardar en sqflite
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

    LogModel.fromMap(Map<String, dynamic> map){
      acceso      = map['acceso'];
      clave       = map['clave'];
      dispositivo = map['dispositivo'];
      fecha       = map['fecha'];
      usuario     = map['usuario'];
      id          = map['id'];
      
      
      
      
      
    }

    //Logica para la persistencia en Firebase
    LogModel({
        this.id,
        this.usuario,
        this.clave,
        this.dispositivo,
        this.acceso,
        this.fecha,
    });

    factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
        id          : json["clave"],
        acceso       : json["acceso"],
        clave       : json["clave"],
        dispositivo  : json["dispositivo"],
        fecha        : json["fecha"], 
        usuario     : json["usuario"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "usuario": usuario,
        "clave": clave,
        "dispositivo": dispositivo,
        "acceso": acceso,
        "fecha": fecha,
    };
}