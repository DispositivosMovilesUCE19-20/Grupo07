import 'dart:io';

import 'package:app_completa2/modelo/log.dart';
import 'package:app_completa2/src/preferencias/preferencias_usuario.dart';
import 'package:app_completa2/src/provider/log_provider.dart';
import 'package:app_completa2/vistas/estudiante_page.dart';
import 'package:app_completa2/vistas/login_page.dart';
import 'package:app_completa2/vistas/usuario_page.dart';
import 'package:flutter/material.dart';


class InicioPage extends StatelessWidget {
//para el firebase
  final logProvider = new LogProvider();
  LogModel log  = new LogModel();
//preferencias de usuario para guradar el log al cerrar sesion
final prefs = new PreferenciaUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          'Modulos del Sistema',
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        
        child: ListView(
          children: <Widget>[
            Container(
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Colors.lightBlueAccent,
                    Colors.blue
                  ])
                ),
                child: Column(
                  children: <Widget>[
                    Icon(Icons.account_circle,
                    size: 110.0,
                    color: Colors.white,),
                  ],
                  
                ),
              ),
              
            ),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.lightBlue,),
              title: Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 20.0),
              
              ),
              
              onTap: (){
                
                Navigator.push(context, LoginPage.route());
                if(Platform.isAndroid){
                  log.acceso = 'Logout';
                  log.dispositivo = 'Android';
                  var now = new DateTime.now();
                  //print(now); 
                  log.fecha = now.toString();
                }
                log.usuario = prefs.usuario;
                log.clave = prefs.clave;
                logProvider.crearLog(log);
                
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),                  
                ),
                color: Colors.lightBlue,
                padding: EdgeInsets.all(10.0),
                child: Text('Usuarios', style: TextStyle(
                  color: Colors.white
                ),),
                onPressed: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UsuarioPage()));
                  
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 100.0,
              height: 50.0,
              child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),                  
              ),
              color: Colors.lightBlue,
              padding: EdgeInsets.all(10.0),
              child: Text('Estudiantes', style: TextStyle(
                color: Colors.white
              ),),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EstudiantePage()));
              },
            ),
            )
          ],
        ),
      ),
    );
  }

  
}
