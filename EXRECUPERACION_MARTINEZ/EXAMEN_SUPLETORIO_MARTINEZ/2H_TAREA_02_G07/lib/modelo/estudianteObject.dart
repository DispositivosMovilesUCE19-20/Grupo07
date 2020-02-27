class EstudianteO {
  int id;
  String nombre;
  String apellido;
  String correo;
  String celular;
  String fecha;
  int genero; // 1 masculino, 0 femenino
  int becado;

  EstudianteO();

  int get getId {
    return id;
  }

  void set setGenero(int genero) {
    this.genero = genero;
  }

  int get getGenero {
    return genero;
  }

  void set setBecado(int becado) {
    this.becado = becado;
  }

  int get getBecado {
    return becado;
  }

  void set setId(int idstudent) {
    this.id = idstudent;
  }

  String get getNombre {
    return nombre;
  }

  void set setNombre(String nombreStudent) {
    this.nombre = nombreStudent;
  }

  String get getApellido {
    return apellido;
  }

  void set setApellido(String apellidoStudent) {
    this.apellido = apellidoStudent;
  }

  String get getCorreo {
    return correo;
  }

  void set setCorreo(String correoStudent) {
    this.correo = correoStudent;
  }

  String get getCelular {
    return celular;
  }

  void set setCelular(String celularStudent) {
    this.celular = celularStudent;
  }

   String get getFecha {
    return fecha;
  }

  void set setFecha(String fechaStudent) {
    this.fecha = fechaStudent;
  }
}
