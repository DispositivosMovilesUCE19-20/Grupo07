import 'package:app_completa3/dbHelper/dbHelper.dart';
import 'package:app_completa3/modelo/estudiante.dart';
import 'package:app_completa3/modelo/estudianteObject.dart';

class CRUDEstudiante {
  DBHelper con = new DBHelper();

  //Inserto un registro en tabla
  Future<Estudiante> registrarEstudiante(Estudiante est) async {
    var dbClient = await con.db;
    est.id = await dbClient.insert('estudiantes', est.toMap());
    return est;
  }

  //Recupera la lista de estudiante
  Future<List<Estudiante>> getEstudiantes(int menu, String parametro) async {
    var dbClient = await con.db;
    print(
        '********************************    LISTADO ESTUDIANTES **************************************');
    List<Map> query = await dbClient.query('estudiantes',
        columns: ['id', 'nombre', 'apellido', 'correo', 'celular', 'fecha', 'genero', 'becado']);

    List<EstudianteO> usuariosOrden = [];
    if (query.length > 0) {
      for (int i = 0; i < query.length; i++) {
        EstudianteO aux = new EstudianteO();
        aux.setId = query[i]['id'];
        aux.setNombre = query[i]['nombre'];
        aux.setApellido = query[i]['apellido'];
        aux.setCorreo = query[i]['correo'];
        aux.setCelular = query[i]['celular'];
        aux.setFecha = query[i]['fecha'];
        aux.setGenero = query[i]['genero'];
        aux.setBecado = query[i]['becado'];
        usuariosOrden.add(aux);
      }
    }

    /**  AQUI SE CAMBIA PARA QUE HACER ASCENDENTE O DESCENDENTE  */
    /**  DE ACUERDO A LO QUE PIDA PONER a.getNombre a.getCelular LO QUE SEA */
    print(menu);
    if (menu == 1 && parametro == 'fecha') {
      usuariosOrden.sort((a, b) => (a.getFecha.compareTo(b.getFecha)));
    } else if (menu == 0 && parametro == 'fecha') {
      usuariosOrden.sort((a, b) => (b.getFecha.compareTo(a.getFecha)));
    } else if (menu == 1 && parametro == 'apellido') {
      usuariosOrden.sort((a, b) => (a.getApellido.toLowerCase().compareTo(b.getApellido.toLowerCase())));
    } else if (menu == 0 && parametro == 'apellido') {
      usuariosOrden.sort((a, b) => (b.getApellido.toLowerCase().compareTo(a.getApellido.toLowerCase())));
    }

    List<Estudiante> estudiantes = [];
    if (usuariosOrden.length > 0) {
      for (int i = 0; i < usuariosOrden.length; i++) {
        Estudiante aux = new Estudiante(
            usuariosOrden[i].getId,
            usuariosOrden[i].getNombre,
            usuariosOrden[i].getApellido,
            usuariosOrden[i].getCorreo,
            usuariosOrden[i].getCelular,
            usuariosOrden[i].getFecha,
            usuariosOrden[i].getGenero,
            usuariosOrden[i].getBecado
            );
        estudiantes.add(aux);
      }
    }
    return estudiantes;
  }

  //Elimina un estudiante
  Future<int> eliminarEstudiante(int idEst) async {
    var dbClient = await con.db;
    return await dbClient
        .delete('estudiantes', where: 'id = ?', whereArgs: [idEst]);
  }

  //Actualizar un Estudiante
  Future<int> actualizarEstudiante(Estudiante est) async {
    var dbClient = await con.db;
    return await dbClient.update('estudiantes', est.toMap(),
        where: 'id = ?', whereArgs: [est.id]);
  }

  //Cierra la conexion
  Future close() async {
    var dbClient = await con.db;
    dbClient.close();
  }
}
