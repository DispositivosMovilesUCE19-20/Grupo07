import 'dart:convert';

LogModel logModelFromJson(String str) => LogModel.fromJson(json.decode(str));

String logModelToJson(LogModel data) => json.encode(data.toJson());

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
      id          = map['id'];
      usuario     = map['usuario'];
      clave       = map['clave'];
      dispositivo = map['dispositivo'];
      acceso      = map['acceso'];
      fecha       = map['fecha'];
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
        id          : json["id"],
        usuario     : json["usuario"],
        clave       : json["clave"],
        dispositivo  : json["dispositivo"],
        acceso       : json["acceso"], 
        fecha        : json["fecha"]    
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