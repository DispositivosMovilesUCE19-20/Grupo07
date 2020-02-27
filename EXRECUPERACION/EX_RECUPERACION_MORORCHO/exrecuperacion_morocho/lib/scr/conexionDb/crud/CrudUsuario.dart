
import 'package:app_completa5/scr/conexionDb/ConexionDb.dart';
import 'package:app_completa5/scr/modelo/Usuario.dart';
import 'package:app_completa5/scr/modelo/UsuarioObject.dart';

class CrudUsuario{
  ConexionDb conn = new ConexionDb();

  //Insertar un registro
  Future<Usuario> registrarUsuario(Usuario usr) async{
    var dbConn = await conn.db;
    usr.id = await dbConn.insert('usuario', usr.toJson());
    return usr;
  }

  //Recuperar lista de usuarios
  Future<List<Usuario>> obtenerUsuarios() async{
    var dbConn = await conn.db;
    List<Map> query = await dbConn.query('usuario', columns: ['id', 'usuario', 'clave']);
    List<UsuarioO> usuariosOrden = [];
    if(query.length > 0){
      for(int i = 0; i < query.length; i++){
        //usuarios.add(Usuario.fromJson(maps[i]));
        UsuarioO aux = new UsuarioO();
        aux.setId = query[i]['id'];
        aux.setUsuario = query[i]['usuario'];
        aux.setClave = query[i]['clave'];
        usuariosOrden.add(aux);
      }
    }

    usuariosOrden.sort((a,b) => (a.getUser.compareTo(b.getUser)));

    List<Usuario> usuarios = [];
    if(usuariosOrden.length > 0){
      for(int j = 0; j < usuariosOrden.length; j++){
        Usuario auxj = new Usuario(usuariosOrden[j].getId, usuariosOrden[j].getUser, usuariosOrden[j].getClave);
        usuarios.add(auxj);
      }
    }

    return usuarios;
  }

  //Recuperar un usuario
  Future<Usuario> getUsuario(String usuario, String clave) async{
    var dbConn = await conn.db;
    List<Map> query = await dbConn.rawQuery("SELECT * FROM usuario WHERE usuario = '$usuario' and clave = '$clave'");
    print('[DBConexion] Cantidad Recuperada: ${query.length} users');
    if(query != null && query.length > 0){
      Usuario usrTemp = Usuario(query[0]['id'], query[0]['usuario'], query[0]['clave']);
      print('[DBConexion] El usuario si existe es: ' + usrTemp.usuario + '---' + usrTemp.clave);
      return usrTemp;
    }else{
      print('[DBConexion] No existe el usuario');
      return null;
    }
  }

  //Elimina un usuario
  Future<int> eliminarUsuario(int id) async{
    var dbConn = await conn.db;
    return await dbConn.delete('usuario', where: 'id=?', whereArgs: [id]);
  }

  //Actualizar un usuario
  Future<int> actualizarUsuario(Usuario usr) async{
    var dbConn = await conn.db;
    return await dbConn.update('usuario', usr.toJson(), where: 'id=?', whereArgs: [usr.id]);
  }

  //Cierra la conexion
  Future close() async{
    var dbConn = await conn.db;
    dbConn.close();
  }

}