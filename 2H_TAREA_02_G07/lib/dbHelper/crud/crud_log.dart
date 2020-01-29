
import 'package:app_completa3/dbHelper/dbHelper.dart';
import 'package:app_completa3/modelo/log.dart';

class CRUDLog{
  DBHelper con = new DBHelper();

  Future<LogModel> registrarUsuario(LogModel log) async{
    var dbClient = await con.db;
    log.id = await dbClient.insert('log', log.toMap());
    return log;
  }
}