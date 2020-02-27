class Usuario{
  int id;
  String usuario;
  String clave;
  
  Usuario(this.id, this.usuario, this.clave);

  Map<String, dynamic> toJson(){
    var json = <String, dynamic>{
      'id'      : id,
      'usuario' : usuario,
      'clave'   : clave
    };
    return json;
  }

  Usuario.fromJson(Map<String, dynamic> json){
    id         = json['id'];
    usuario    = json['usuario'];
    clave      = json['clave'];
  }
}