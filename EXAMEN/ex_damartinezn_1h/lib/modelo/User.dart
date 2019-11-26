class User {
  int id;
  String name;
  String apellido;
  String cedula;
  String correo;
  String direccion;
  String foto;
  String sexo;
  String fecha;
  String beca;
  String materias;

  String user;
  String password;

  User(
      this.id,
      this.name,
      this.apellido,
      this.cedula,
      this.correo,
      this.direccion,
      this.foto,
      this.sexo,
      this.fecha,
      this.beca,
      this.materias,
      this.user,
      this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'apellido': apellido,
      'cedula': cedula,
      'correo': correo,
      'direccion': direccion,
      'foto': foto,
      'sexo': sexo,
      'fecha': fecha,
      'beca': beca,
      'materias': materias,
      'user': user,
      'password': password,
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    apellido = map['apellido'];
    cedula = map['cedula'];
    correo = map['correo'];
    direccion = map['direccion'];
    foto = map['foto'];
    sexo = map['sexo'];
    fecha = map['fecha'];
    beca = map['beca'];
    materias = map['materias'];
    user = map['user'];
    password = map['password'];
  }

  int get _id => id;
  String get _name => name;
  String get _apellido => apellido;
  String get _cedula => cedula;
  String get _correo => correo;
  String get _direccion => direccion;
  String get _foto => foto;
  String get _sexo => sexo;
  String get _fecha => fecha;
  String get _beca => beca;
  String get _materias => materias;
  String get _user => user;
  String get _password => password;
}
