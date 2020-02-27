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
    print('***************************************************  desde get ***************************');    
    _db = await initDatabase();
    print(_db.isOpen);
    return _db;
  }

  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'optativa3.db');
    print('Pathhhhhh de la db');
    print(documentDirectory.path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    print('************  DESDE   DBHELPER   *********************');
    print(db.isOpen);
    return db;
  }

  //Crea las tablas en la base
  _onCreate(Database db, int version) async{
    await db.execute('CREATE TABLE usuario (id INTEGER PRIMARY KEY, usuario TEXT, clave TEXT)');
    await db.execute('CREATE TABLE estudiantes (id INTEGER PRIMARY KEY, nombre TEXT, apellido TEXT, correo TEXT, celular TEXT, fecha TEXT, genero INTEGER, becado INTEGER)');
    await db.execute('CREATE TABLE log (id INTEGER PRIMARY KEY, usuario TEXT, clave TEXT, dispositivo TEXT, acceso TEXT, fecha TEXT)');
  
  }

  _onClose(Database db) async{
    await db.close();
  }


}