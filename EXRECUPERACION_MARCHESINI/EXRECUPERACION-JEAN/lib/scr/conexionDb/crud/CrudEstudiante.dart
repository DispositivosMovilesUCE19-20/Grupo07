import 'package:app_completa5/scr/conexionDb/ConexionDb.dart';
import 'package:app_completa5/scr/modelo/Estudiante.dart';
import 'package:app_completa5/scr/modelo/EstudianteObject.dart';

class CrudEstudiante {
  ConexionDb conn = new ConexionDb();

  //Insertar un registro en la tabla
  Future<Estudiante> crearEstudiante(Estudiante est) async {
    var dbConn = await conn.db;
    est.id = await dbConn.insert('estudiante', est.toJson());
    print('Estudiante Creado');
    return est;
  }

  //Recuperar lista de estudiante

  Future<List<Estudiante>> obtenerTodos(int menu, String parametro) async {
    var dbConn = await conn.db;
    print('***** LISTADO ESTUDIANTES *****');
    List<Map> query = await dbConn.query('estudiante', columns: [
      'id',
      'nombre',
      'apellido',
      'correo',
      'celular',
      'genero',
      'fechaNacimiento',
      'becado'
    ]);
    List<EstudianteO> estudianteOrden = [];
    if(query.length > 0){
      for(int i = 0; i < query.length; i++){
        EstudianteO aux = new EstudianteO();
        aux.setId = query[i]['id'];
        aux.setNombre = query[i]['nombre'];
        aux.setApellido = query[i]['apellido'];
        aux.setCorreo = query[i]['correo'];
        aux.setCelular = query[i]['celular'];
        aux.setGenero = query[i]['genero'];
        aux.setFecha = query[i]['fechaNacimiento'];
        aux.setBecado = query[i]['becado'];
        estudianteOrden.add(aux);
      }
    }

    /**  AQUI SE CAMBIA PARA QUE HACER ASCENDENTE O DESCENDENTE  */
    /**  DE ACUERDO A LO QUE PIDA PONER a.getNombre a.getCelular LO QUE SEA */
    print(menu);
    if (menu == 1 && parametro == 'fecha') {
      estudianteOrden.sort((a, b) => (a.getFecha.toLowerCase().compareTo(b.getFecha.toLowerCase())));
    } else if (menu == 0 && parametro == 'fecha') {
      estudianteOrden.sort((a, b) => (b.getFecha.compareTo(a.getFecha)));
    } else if (menu == 1 && parametro == 'apellido') {
      estudianteOrden.sort((a, b) => (a.getApellido.compareTo(b.getApellido)));
    } else if (menu == 0 && parametro == 'apellido') {
      estudianteOrden.sort((a, b) => (b.getApellido.compareTo(a.getApellido)));
    }

    List<Estudiante> estudiantes = [];
    if(estudianteOrden.length > 0){
      for(int i = 0; i < estudianteOrden.length; i++){
        Estudiante aux = new Estudiante(
          estudianteOrden[i].getId,
          estudianteOrden[i].getNombre,
          estudianteOrden[i].getApellido,
          estudianteOrden[i].getCorreo,
          estudianteOrden[i].getCelular,
          estudianteOrden[i].getGenero,
          estudianteOrden[i].getFecha,
          estudianteOrden[i].getBecado
        );
        estudiantes.add(aux);
      }
    }

    return estudiantes;
  }

  //Eliminar un estudiante
  Future<int> eliminarEstudiante(int id) async {
    var dbConn = await conn.db;
    print('Se elimino el estudiante');
    return await dbConn
        .delete('estudiante', where: 'id=? and becado=?', whereArgs: [id, 0]);
  }

  //Actualizar un estudiante
  Future<int> actualizarEstudiante(Estudiante est) async {
    var dbConn = await conn.db;
    print('Se actualizo el estudiante');
    return await dbConn
        .update('estudiante', est.toJson(), where: 'id=?', whereArgs: [est.id]);
  }

  //Cerrar la conexion
  Future close() async {
    var dbConn = await conn.db;
    dbConn.close();
  }
}
