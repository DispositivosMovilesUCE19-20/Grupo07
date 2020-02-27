class Usuario {
  int id;
  String usuario;
  String clave;

  int get getId {
    return id;
  }

  void set setId(int iduser) {
    this.id = iduser;
  }

  String get getUser {
    return usuario;
  }

  void set setUsuario(String userS) {
    this.usuario = userS;
  }

  String get getClave {
    return clave;
  }

  void set setClave(String claves) {
    this.clave = claves;
  }

  

  Usuario(this.id, this.usuario, this.clave);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'usuario': usuario, 'clave': clave};
    return map;
  }

  Usuario.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    usuario = map['usuario'];
    clave = map['clave'];
  }
}
