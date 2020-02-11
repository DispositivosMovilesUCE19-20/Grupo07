
import 'package:app_completa3/dbHelper/dbHelper.dart';
import 'package:app_completa3/modelo/estudiante.dart';

class CRUDEstudiante{

  DBHelper con = new DBHelper();

  //Inserto un registro en tabla
  Future<Estudiante> registrarEstudiante(Estudiante est) async{
    var dbClient = await con.db;
    est.id = await dbClient.insert('estudiantes', est.toMap());
    return est;
  }

  //Recupera la lista de estudiante
  Future<List<Estudiante>> getEstudiantes() async{
    var dbClient = await con.db;
    List<Map> maps = await dbClient.query('estudiantes', columns: ['id', 'nombre', 'apellido', 'correo', 'celular']);
    List<Estudiante> estudiantes = [];
    if(maps.length > 0){
      for(int i = 0; i< maps.length; i++){
        estudiantes.add(Estudiante.fromMap(maps[i]));
      }
    }
    return estudiantes;
  }

  //Elimina un estudiante
  Future<int> eliminarEstudiante(int idEst) async{
    var dbClient = await con.db;
    return await dbClient.delete('estudiantes', where: 'id = ?', whereArgs: [idEst]);
  }

  //Actualizar un Estudiante
  Future<int> actualizarEstudiante(Estudiante est) async{
    var dbClient = await con.db;
    return await dbClient.update('estudiantes', est.toMap(), where: 'id = ?', whereArgs: [est.id]);
  }

  //Cierra la conexion
  Future close() async{
    var dbClient = await con.db;
    dbClient.close();
  }
}