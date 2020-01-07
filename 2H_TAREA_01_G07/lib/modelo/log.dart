import 'dart:convert';

LogModel logModelFromJson(String str) => LogModel.fromJson(json.decode(str));

String logModelToJson(LogModel data) => json.encode(data.toJson());

class LogModel {
    String id;
    String usuario;
    String clave;
    String dispositivo;
    String acceso;
    String fecha;

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