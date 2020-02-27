import 'package:app_completa3/dbHelper/dbHelper.dart';
import 'package:app_completa3/modelo/ejemplo.dart';
import 'package:app_completa3/modelo/usuario.dart';
import 'package:app_completa3/modelo/usuarioObject.dart';

class CRUDUsuario {
  DBHelper con = new DBHelper();

  //insertar registro
  Future<Usuario> registrarUsuario(Usuario usr) async {
    print(usr.toMap());
    var dbClient = await con.db;
    print(
        '**************************   GUARDANDO  ***************************');
    print(dbClient.isOpen);
    usr.id = await dbClient.insert('usuario', usr.toMap());
    return usr;
  }

  List<Employee> ejecutar() {
    //Create a list of employees and their respective sales
    List<Employee> employees = new List<Employee>();
    employees.add(new Employee(1, [new Sale(1, 100.50), new Sale(1, 300.25)]));
    employees.add(new Employee(
        2, [new Sale(2, 300.00), new Sale(2, 50.25), new Sale(2, 150.00)]));
    employees.add(new Employee(
        3, [new Sale(2, 400.00), new Sale(2, 30.75), new Sale(3, 50.00)]));
    //Sort so that the employee with the most sales is on top and so on...
    employees.sort((a, b) => (b.sales
            .fold(0, (prev, element) => prev + element.price))
        .compareTo(a.sales.fold(0, (prev, element) => prev + element.price)));
    log(employees); //prints Employee #2, followed by Employee #3, then ending with Employee #1
    return employees;
  }

  void log(var lst) {
    lst.forEach((l) => print(
        "Employee #${l.id} has ${l.sales.length} sales totaling ${l.sales.fold(0, (prev, element) => prev + element.price)} dollars!"));
  }

  //Recupera la lista de usuarios
  Future<List<Usuario>> getUsuarios() async {
    var dbClient = await con.db;
    print(dbClient.isOpen);
    List<Map> query =
        await dbClient.query('usuario', columns: ['id', 'usuario', 'clave']);
    

    List<UsuarioO> usuariosOrden = [];
    if (query.length > 0) {
      for (int i = 0; i < query.length; i++) {
        UsuarioO aux = new UsuarioO();
        aux.setId = query[i]['id'];
        aux.setUsuario = query[i]['usuario'];
        aux.setClave = query[i]['clave'];
        usuariosOrden.add(aux);
      }
    }

    usuariosOrden.sort((a,b) =>(a.getUser.compareTo(b.getUser)));
   /** mayo a menor  usuariosOrden.sort((a,b) =>(a.getUser.compareTo(b.getUser))); */
    
    List<Usuario> usuarios = [];
    if (usuariosOrden.length > 0) {
      for (int j = 0; j < usuariosOrden.length; j++) {
        Usuario auxj = new Usuario(usuariosOrden[j].getId,
            usuariosOrden[j].getUser, usuariosOrden[j].getClave);
        usuarios.add(auxj);
      }
    }
    return usuarios;
  }

  //Recupera un usuario
  Future<List<Usuario>> getUsuario(String usuario, String clave) async {
    var dbClient = await con.db;
    print(dbClient.isOpen);
    List<Usuario> lista = List();
    print('************************************');
    print(usuario + " " + clave);
    List<Map> query = await dbClient.rawQuery(
        "SELECT * FROM usuario WHERE usuario = \'${usuario}\' and clave = \'${clave}\' ;");
    print('[DBHelper] getUser: ${query.length} users');

    if (query != null && query.length > 0) {
      for (int i = 0; i < query.length; i++) {
        Usuario aux =
            new Usuario(query[i]['id'], query[i]['usuario'], query[i]['clave']);
        ;
        lista.add(aux);
      }

      return lista;
    } else {
      print('[DBHelper] getUser: User is null');
      return null;
    }
  }

  //Elimina un usuario
  Future<int> eliminarUsuario(int idUsr) async {
    var dbClient = await con.db;
    return await dbClient
        .delete('usuario', where: 'id = ?', whereArgs: [idUsr]);
  }

  //Actualizar un usuario
  Future<int> actualizarUsuario(Usuario usr) async {
    var dbClient = await con.db;
    return await dbClient
        .update('usuario', usr.toMap(), where: 'id = ?', whereArgs: [usr.id]);
  }

  //Cierra la conexion
  Future close() async {
    var dbClient = await con.db;
    dbClient.close();
  }
}
