import 'package:app_completa2/dbHelper/dbHelper.dart';
import 'package:app_completa2/modelo/usuario.dart';
import 'package:flutter/material.dart';


class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  

  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();

  Future<List<Usuario>> usuarios;
  String _usuario;
  String _clave;
  bool isUpdate = false;
  int usuarioIdForUpdate;

  DBHelper dbHelper;
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    dbHelper = DBHelper();
    refrescarListaUsuarios();
  }

  refrescarListaUsuarios(){
    setState(() {
      usuarios = dbHelper.getUsuarios();
    });
  }


  @override
  Widget build(BuildContext context) {

    //mostrar la notificacion
    final argumento = ModalRoute.of(context).settings.arguments;
    //print(isUpdate);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.all(5.0),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Modulo de Usuarios',
          style: TextStyle(color: Colors.white),
          
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.people,
            color: Colors.white,),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(argumento ?? ''),
          Form(
            key: _formStateKey,
            //autovalidate: true,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: TextFormField(
                    validator: (value){
                      if (value.isEmpty){
                        return 'Ingrese el usuario';
                      }
                      if(value.trim()==""){
                        return "Espacio en blanco no es valido";
                      }
                      return null;
                    },
                    onSaved: (value){
                      _usuario = value;
                    },
                    controller: _usuarioController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 2,
                          style: BorderStyle.solid
                        ),                    
                      ),
                      labelText: "Usuario",
                      icon: Icon(
                        Icons.person,
                        color: Colors.lightBlue,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.lightBlue
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'Ingrese la clave del usuario';
                      }
                      if(value.trim()==""){
                        return 'Espacio en blanco no es valido';
                      }
                      return null;
                    },
                    onSaved: (value){
                      _clave = value;
                    },
                    controller: _claveController,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.lightBlue,
                          width: 2,
                          style: BorderStyle.solid
                        ),
                      ),
                      labelText: "Clave",
                      icon: Icon(
                        Icons.security,
                        color: Colors.lightBlue,
                      ),
                      fillColor: Colors.lightBlue,
                      labelStyle: TextStyle(
                        color: Colors.lightBlue
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.lightBlue,
                child: Text(
                  (isUpdate ? 'Actualizar' : 'Insertar'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  if(isUpdate){
                    //print(isUpdate);
                    if(_formStateKey.currentState.validate()){
                      _formStateKey.currentState.save();
                      dbHelper.actualizarUsuario(Usuario(usuarioIdForUpdate, _usuario, _clave))
                              .then((data){
                                setState(() {
                                  isUpdate = false;
                                });
                              });
                    }
                  }else{
                    if(_formStateKey.currentState.validate()){
                      _formStateKey.currentState.save();
                      dbHelper.registrarUsuario(Usuario(null, _usuario, _clave));
                    }
                  }
                  _usuarioController.text = '';
                  _claveController.text = '';
                  refrescarListaUsuarios();
                },
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              RaisedButton(
                color: Colors.lightBlue,
                child: Text(
                  (isUpdate ? 'Cancelar' : 'Limpiar'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: (){
                  _usuarioController.text = '';
                  _claveController.text = '';
                  setState(() {
                    isUpdate = false;
                    usuarioIdForUpdate = null;
                  });
                },
              )
            ],
          ),
          const Divider(
            height: 5.0,
          ),
          Expanded(
            child: FutureBuilder(
              future: usuarios,
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return generarLista(snapshot.data);                  
                }
                if(snapshot.data == null || snapshot.data.length == 0){
                  return Text('No hay registros');
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          
        ],
      ),
    );
  }

  SingleChildScrollView generarLista(List<Usuario> usuarios) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: DataTable(
          columnSpacing: 45,
          headingRowHeight: 30,
          
          columns: [
            DataColumn(
              label: Text('Id')
            ),
            DataColumn(
              label: Text('Usuario')
            ),
            DataColumn(
              label: Text('Clave')
            ),
            DataColumn(
              label: Text('Eliminar')
            )
          ],
          rows: usuarios.map(
            (usuario)=>DataRow(
              cells: [
                DataCell(Text(usuario.id.toString())),
                DataCell(
                  Text(usuario.usuario),
                  onTap: (){
                    setState(() {
                      isUpdate = true;
                      usuarioIdForUpdate = usuario.id;
                    });
                    _usuarioController.text = usuario.usuario;
                    _claveController.text = usuario.clave;
                  }
                ),
                DataCell(
                  Text(usuario.clave),
                  onTap: (){
                    setState(() {
                      isUpdate = true;
                      usuarioIdForUpdate = usuario.id;
                    });
                    _usuarioController.text = usuario.usuario;
                    _claveController.text = usuario.clave;
                  }
                ),
                DataCell(
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: (){
                      dbHelper.eliminarUsuario(usuario.id);
                      refrescarListaUsuarios();
                    },
                  )
                )
              ]
            )
          ).toList(),
        ),
      ),
    );
  }

  
}
