import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    final men = AppBar(
      //automaticallyImplyLeading: false,
      backgroundColor: Colors.lightBlueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Bienvenido',
        style:
            TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'Nunito'),
        textAlign: TextAlign.right,
      ),
      actions: <Widget>[
        PopupMenuButton(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text("Salir"),
            ),
          ],
        )
      ],
    );

    final foto = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/foto.jpg'),
        ),
      ),
    );

    final nombre = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Aquí el Nombre',
        style: TextStyle(fontSize: 28.0, color: Colors.black38),
      ),
    );

    final apellido = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Aquí el Apellido',
        style: TextStyle(fontSize: 28.0, color: Colors.black38),
      ),
    );

    final email = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Aquí el Email',
        style: TextStyle(fontSize: 28.0, color: Colors.black38),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.white,
          Colors.white,
        ]),
      ),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[men, foto, nombre, apellido, email],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: body,
    );
  }
}
