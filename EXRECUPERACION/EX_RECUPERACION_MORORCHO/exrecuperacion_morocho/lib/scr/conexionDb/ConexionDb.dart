import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class ConexionDb{

  static Database _db;

  Future<Database> get db async{
    if(_db != null){
      print('La BD ya existe');
      return _db;
    }
    _db = await initDatabase();
    print('La BD fue accedida');
    print(_db.isOpen);
    return _db;
  }

  initDatabase() async{
    io.Directory documentoDirectorio = await getApplicationDocumentsDirectory();
    String path = join(documentoDirectorio.path, 'test2.db');
    var db = await openDatabase(path, version: 1, onCreate: _crearBD);
    return db;
  }

  _crearBD(Database db, int version) async{
    await db.execute('CREATE TABLE estudiante (id INTEGER PRIMARY KEY, nombre TEXT, apellido TEXT, correo TEXT, celular TEXT, genero INTEGER, fechaNacimiento TEXT, becado INTEGER)');
    await db.execute('CREATE TABLE usuario (id INTEGER PRIMARY KEY, usuario TEXT, clave TEXT)');
    await db.execute('CREATE TABLE log (id INTEGER PRIMARY KEY, usuario TEXT, clave TEXT, dispositivo TEXT, acceso TEXT, fecha TEXT)');
  }
}