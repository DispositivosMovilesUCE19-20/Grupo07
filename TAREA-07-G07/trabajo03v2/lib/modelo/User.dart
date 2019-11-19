class User{
  int id;
  String name;
  String apellido;
  String cedula;
  String correo;
  String direccion;
  String foto;

  String user;
  String password;

  

  User(this.id, this.name, this.apellido, this.cedula, this.correo, this.direccion, this.foto, this.user, this.password);

  Map<String, dynamic> toMap(){
    var map =<String,dynamic>{
      'id': id,
      'name': name,
      'apellido': apellido,
      'cedula':cedula,
      'correo':correo,
      'direccion':direccion,
      'foto':foto,
      'user':user,
      'password':password,
    };
    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    id = map['id'];
    name = map['name'];
    apellido = map['apellido'];
    cedula = map['cedula'];
    correo = map['correo'];
    direccion = map['direccion'];
    foto = map['foto'];
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
  String get _user => user;
  String get _password => password;

}