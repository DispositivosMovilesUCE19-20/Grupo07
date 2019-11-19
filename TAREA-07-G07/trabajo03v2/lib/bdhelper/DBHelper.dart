
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:trabajo03v2/modelo/User.dart';

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'student.db');
    var db = await openDatabase(path,version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    await db.execute(
        'CREATE TABLE student (id INTEGER PRIMARY KEY, name TEXT, apellido TEXT, cedula TEXT, correo TEXT, direccion TEXT, foto TEXT, user TEXT, password TEXT)'
    );
  }

  Future<User> add(User student) async {
    var dbClient = await db;
    student.id = await dbClient.insert('student', student.toMap());
    return student;
  }

  Future<int> newClient(User newClient) async {
    final dbClient = await db;
    var res = await dbClient.rawInsert(
        "INSERT Into student (id,name,apellido,cedula,correo,direccion,foto,user,password) VALUES (((SELECT MAX(id) FROM student)+1),\'${newClient.name}\', \'${newClient.apellido}\',\'${newClient.cedula}\',\'${newClient.correo}\',\'${newClient.direccion}\',\'${newClient.foto}\',\'${newClient.user}\',\'${newClient.password}\')");
    return res;
  }

  Future<List<User>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('student', columns: ['id', 'name','apellido','cedula','correo','direccion','foto','user','password']);
    List<User> students = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        students.add(User.fromMap(maps[i]));
      }
    }
    return students;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(
      'student',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(User student) async {
    var dbClient = await db;
    return await dbClient.update(
      'student',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  //para listar solo uno
  Future<List<User>> buscarUnDato(String user, String pass) async{
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM student WHERE name = \'${user}\' AND apellido = \'${pass}\'');
    List<User> datos = new List();
    for(int i; i < list.length;i++){
      User dato = new User(list[i]['id'],list[i]['name'], list[i]['apellido'], list[i]['cedula'], list[i]['correo'], list[i]['direccion'], list[i]['foto'], list[i]['user'],list[i]['password']);
      datos.add(dato);
    }
    return datos;
  }

  //para listar solo uno
  Future<User> buscareUnDato(String user, String pass) async{
    var db_connection = await db;
    List<Map> list = await db_connection.rawQuery('SELECT * FROM student WHERE name = \'${user}\' AND apellido = \'${pass}\'');
    User datos;
    for(int i; i < list.length;i++){
      datos = new User(list[i]['id'],list[i]['name'], list[i]['apellido'], list[i]['cedula'], list[i]['correo'], list[i]['direccion'], list[i]['foto'], list[i]['user'],list[i]['password']);
    }
    return datos;
  }

  Future<List<User>> getUser(String email, String password) async {
    var dbClient = await db;
    List<User> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM student WHERE user = \'${email}\' AND password = \'${password}\'',
    );
    //print('[DBHelper] getUser: ${queryList.length} users');
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        usersList.add(User(
          queryList[i]['id'],
          queryList[i]['name'],
          queryList[i]['apellido'],
          queryList[i]['cedula'],
          queryList[i]['correo'],
          queryList[i]['direccion'],
          queryList[i]['foto'],
          queryList[i]['user'],
          queryList[i]['password'],
        ));
      }
      return usersList;
    } else {
      print('[DBHelper] getUser: User is null');
      return null;
    }
  }


  Future<User> getUser2(String email, String password) async {
    var dbClient = await db;
    List<User> usersList = List();
    List<Map> queryList = await dbClient.rawQuery(
      'SELECT * FROM student WHERE user = \'${email}\' AND password = \'${password}\'',
    );
    //print('[DBHelper] getUser: ${queryList.length} users');
    if (queryList != null && queryList.length > 0) {
      for (int i = 0; i < queryList.length; i++) {
        usersList.add(User(
          queryList[i]['id'],
          queryList[i]['name'],
          queryList[i]['apellido'],
          queryList[i]['cedula'],
          queryList[i]['correo'],
          queryList[i]['direccion'],
          queryList[i]['foto'],
          queryList[i]['user'],
          queryList[i]['password'],
        ));
      }
      User us = new User(usersList[0].id, usersList[0].name, usersList[0].apellido, usersList[0].cedula, usersList[0].correo, usersList[0].direccion, usersList[0].foto, usersList[0].user, usersList[0].password);
      print(us.id.toString());
      return us;
    } else {
      print('[DBHelper] getUser: User is null');
      return null;
    }
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
