class UsuarioO {
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

  UsuarioO();

}