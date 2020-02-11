
import 'package:app_completa3/dbHelper/dbHelper.dart';
import 'package:app_completa3/modelo/usuario.dart';

class CRUDUsuario{
  
  DBHelper con = new DBHelper();

  //insertar registro
  Future<Usuario> registrarUsuario(Usuario usr) async{
    var dbClient = await con.db;
    usr.id = await dbClient.insert('usuario', usr.toMap());
    return usr;
  }

  //Recupera la lista de usuarios
  Future<List<Usuario>> getUsuarios() async{
    var dbClient = await con.db;
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
    var dbClient = await con.db;
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
  }

  //Elimina un usuario
  Future<int> eliminarUsuario(int idUsr) async{
    var dbClient = await con.db;
    return await dbClient.delete('usuario', where: 'id = ?', whereArgs: [idUsr]);
  }

  //Actualizar un usuario
  Future<int> actualizarUsuario(Usuario usr) async{
    var dbClient = await con.db;
    return await dbClient.update('usuario', usr.toMap(), where: 'id = ?', whereArgs: [usr.id]);
  }

  //Cierra la conexion
  Future close() async{
    var dbClient = await con.db;
    dbClient.close();
  }

  


}