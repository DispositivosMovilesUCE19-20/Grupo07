class Estudiante{
  int id;
  String nombre;
  String apellido;
  String correo;
  String celular;
  int genero; // 1 masculino, 0 femenino
  String fechaNacimiento;
  int becado; // 1 si, 0 no
  

  Estudiante(this.id, this.nombre, this.apellido, this.correo, this.celular, this.genero, this.fechaNacimiento, this.becado);

  Map<String, dynamic> toJson(){
    var json = <String, dynamic>{
      'id'              : id,
      'nombre'          : nombre,
      'apellido'        : apellido,
      'correo'          : correo,
      'celular'         : celular,
      'genero'          : genero,
      'fechaNacimiento' : fechaNacimiento,
      'becado'          : becado
    };
    return json;
  }

  Estudiante.fromJson(Map<String, dynamic> json){
    id              = json['id'];
    nombre          = json['nombre'];
    apellido        = json['apellido'];
    correo          = json['correo'];
    celular         = json['celular'];
    genero          = json['genero'];
    fechaNacimiento = json['fechaNacimiento'];
    becado          = json['becado'];
  }
}