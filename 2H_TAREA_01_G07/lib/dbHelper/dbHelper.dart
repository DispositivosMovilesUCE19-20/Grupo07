
import 'package:app_completa2/modelo/usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper{
  static Database _db;
  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'usuario.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
  //Creo la tabla en la base
  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE usuario (id INTEGER PRIMARY KEY, usuario TEXT, clave TEXT)');
  }

  //Inserto un registro en tabla
  Future<Usuario> registrarUsuario(Usuario usr) async{
    var dbClient = await db;
    usr.id = await dbClient.insert('usuario', usr.toMap());
    return usr;
  }

  //Recupera la lista de usuarios
  Future<List<Usuario>> getUsuarios() async{
    var dbClient = await db;
    List<Map> maps = await dbClient.query('usuario', columns: ['id', 'usuario', 'clave']);
    List<Usuario> usuarios = [];
    if(maps.length > 0){
      for(int i = 0; i< maps.length; i++){
        usuarios.add(Usuario.fromMap(maps[i]));
      }
    }
    return usuarios;
  }

  //Recupera un usuario
  Future<List<Usuario>> getUsuario(String usuario, String clave) async{
    var dbClient = await db;
    List<Usuario> lista = List();
    List<Map> query = await dbClient.rawQuery("SELECT * FROM usuario WHERE usuario = '$usuario' and clave = '$clave'");
    print('[DBHelper] getUser: ${query.length} users');
    if(query != null && query.length > 0){
      for(int i = 0; i < query.length; i++){
        lista.add(Usuario(
          query[i]['id'],
          query[i]['usuario'],
          query[i]['clave']
        ));
      }
      print('[DBHelper] getUser: ${lista[0].usuario}');
      return lista;
    }else{
      print('[DBHelper] getUser: User is null');
      return null;
    }
    //var res = await dbClient.rawQuery("SELECT * FROM usuario WHERE usuario = '$usuario' and clave = '$clave'");
    //if(res.length > 0){
    //  print(res);
    //  return Usuario.fromMap(res.first);
    //}
    //print(res);
    //return null;
  }

  //Elimina un usuario
  Future<int> eliminarUsuario(int idUsr) async{
    var dbClient = await db;
    return await dbClient.delete('usuario', where: 'id = ?', whereArgs: [idUsr]);
  }

  //Actualizar un usuario
  Future<int> actualizarUsuario(Usuario usr) async{
    var dbClient = await db;
    return await dbClient.update('usuario', usr.toMap(), where: 'id = ?', whereArgs: [usr.id]);
  }

  //Cierra la conexion
  Future close() async{
    var dbClient = await db;
    dbClient.close();
  }





}