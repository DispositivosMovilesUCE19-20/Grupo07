class Usuario{
  int id;
  String usuario;
  String clave;

  Usuario(this.id, this.usuario, this.clave);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id'         : id,
      'usuario'    : usuario,
      'clave'      : clave   
    };
    return map;
  }

  Usuario.fromMap(Map<String,dynamic> map){
    id      = map['id'];
    usuario = map['usuario'];
    clave   = map['clave'];
  }
}