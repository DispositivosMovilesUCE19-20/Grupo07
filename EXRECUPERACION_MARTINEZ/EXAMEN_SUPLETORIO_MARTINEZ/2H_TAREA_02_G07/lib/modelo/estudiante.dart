class Estudiante{
  int id;
  String nombre;
  String apellido;
  String correo;
  String celular;
  String fecha;
  int genero; // 1 masculino, 0 femenino
  int becado; // 1 si, 0 no

  Estudiante(this.id, this.nombre, this.apellido, this.correo, 
  this.celular, this.fecha, this.genero, this.becado);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id'         :id,
      'nombre'     :nombre,
      'apellido'   :apellido,
      'correo'     :correo,
      'celular'    :celular,
      'fecha'      :fecha,
      'genero'     : genero,
      'becado'     : becado
    };
    return map;
  }

  Estudiante.fromMap(Map<String, dynamic> map){
    id       = map['id'];
    nombre   = map['nombre'];
    apellido = map['apellido'];
    correo   = map['correo'];
    celular  = map['celular']; 
    fecha    = map['fecha']; 
    genero   = map['genero'];    
    becado   = map['becado'];
  }

}