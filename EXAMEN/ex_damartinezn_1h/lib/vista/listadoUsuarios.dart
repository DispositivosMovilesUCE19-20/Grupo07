import 'package:flutter/material.dart';
import 'package:proyecto_final_g07/controlador/DBHelper.dart';

import 'package:proyecto_final_g07/modelo/Mensaje.dart';
import 'package:proyecto_final_g07/modelo/User.dart';
import 'package:proyecto_final_g07/rest/mensaje_provider.dart';
import 'package:toast/toast.dart';

import 'MostrarDatos.dart';


class listadoUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ListadoPage(),
    );
  }
}

class ListadoPage extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<ListadoPage> {
  Future<List<User>> listUser;
  List<User> listAux;
  DBHelper dbHelper;
  Future<List<User>> students;

  bool isUpdate = false;
  int studentIdForUpdate;

  final mensajeProvider = new MensajeProvider();
  Future<List<Mensaje>> lista;
  String mensajeText, mensajeTextE, mensajeTextEE;
  final String url = "mensajeEliminado";
  final String urlE = "mensajeErrorEliminado";
  final String urlG7 = "mensajeGrupo07";
  Future<String> men;
  Mensaje aux;

  @override
  void initState() {
    super.initState();
    //mensaje rest
    lista = mensajeProvider.getData();
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          aux = new Mensaje(lisMensaje[0].msg);
          mensajeText = aux.msg.toString();
        });
      }
    });
    //****************************************************
    lista = mensajeProvider.mensajeImprimir(url);
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          aux = new Mensaje(lisMensaje[0].msg);
          mensajeTextE = aux.msg.toString();
        });
      }
    });
    //*****************************************************
    lista = mensajeProvider.mensajeImprimir(url);
    lista.then((List<Mensaje> lisMensaje) {
      if (lisMensaje != null && lisMensaje.length > 0) {
        setState(() {
          aux = new Mensaje(lisMensaje[0].msg);
          mensajeTextEE = aux.msg.toString();
        });
      }
    });
    //*****************************************************

    dbHelper = DBHelper();
    refreshStudentList();
  }

  refreshStudentList() {
    setState(() {
      students = dbHelper.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Listado de Usuarios"),
          backgroundColor: Colors.blue[700],
        ),
        backgroundColor: Colors.blue[700],
        body: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                if (mensajeText == null)
                  CircularProgressIndicator()
                else
                  Text(
                    "${mensajeText}", // ignore: unnecessary_brace_in_string_interps
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
              ],
            ),
            new Container(
              margin: new EdgeInsets.only(top: 0.0, left: 140.0, right: 140),
              padding: EdgeInsets.all(00.0),
              height: 80,
              width: 120.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(200),
                color: Colors.blueGrey[100],
              ),
              child: ImagenCargar(),
            ),
            Container(
              margin: new EdgeInsets.only(
                  top: 0, left: 10.0, right: 10.0, bottom: 0),
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.lightBlueAccent[400],
                    offset: new Offset(10.0, 10.0),
                    blurRadius: 30.0,
                  )
                ],
                borderRadius: new BorderRadius.circular(20),
                color: Colors.lightBlue[200],
              ),
              child: new FutureBuilder(
                future: students,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return generateList(snapshot.data);
                  }
                  if (snapshot.data == null || snapshot.data.length == 0) {
                    return Text('No Data Found');
                  }
                  return CircularProgressIndicator();
                },
              ),
            )
          ],
        ));
  }

  SingleChildScrollView generateList(List<User> students) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'NOMBRES',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'APELLIDOS',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'DELETE',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    fontSize: 11),
              ),
            )
          ],
          rows: students
              .map(
                (student) => DataRow(
                  cells: [
                    DataCell(
                      Text(student.name),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new MostrarPage(usuario: student),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    DataCell(
                      Text(student.apellido),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new MostrarPage(usuario: student),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    DataCell(
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Toast.show(mensajeTextE, context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          dbHelper.delete(student.id).then((int aux){
                            if(aux>0){
                              Toast.show(
                                  mensajeTextE,
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }else{
                              Toast.show(
                                  mensajeTextEE,
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }
                          });
                          refreshStudentList();
                        },
                      ),
                    )
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class ImagenCargar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imagen = new AssetImage('assets/user2.png');
    var img = new Image(
      image: imagen,
      width: 150.0,
      height: 150.0,
    );
    return new Container(
      child: img,
    );
  }
}
