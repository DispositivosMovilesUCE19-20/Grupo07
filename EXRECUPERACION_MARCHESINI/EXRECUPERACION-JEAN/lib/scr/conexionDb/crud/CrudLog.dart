
import 'package:app_completa5/scr/conexionDb/ConexionDb.dart';
import 'package:app_completa5/scr/modelo/Log.dart';

class CrudLog{
  ConexionDb conn = new ConexionDb();

  Future<Log> registrarLog(Log log) async{
    var dbConn = await conn.db;
    log.id = await dbConn.insert('log', log.toMap());
    return log;
  }
}