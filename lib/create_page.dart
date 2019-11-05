import 'package:flutter/material.dart';


class CreatePage extends StatelessWidget {
  static String tag = 'create-page';

  @override
  Widget build(BuildContext context) {
    final men = AppBar(
      //automaticallyImplyLeading: false,
      backgroundColor: Colors.lightGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        'Registro Nuevo',
        style: TextStyle(            
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Nunito'),
      ),
      actions: <Widget>[       
        
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

    final nombre = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,      
      decoration: InputDecoration(
        hintText: 'Nombre',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    
    final apellido = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,      
      decoration: InputDecoration(
        hintText: 'Apellido',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,      
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


    final registrar = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(CreatePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightGreen,
        child: Text('Crear Usuario', style: TextStyle(color: Colors.white)),
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
        
        children: <Widget>[
        
        men,
        SizedBox(height: 10.0),
        foto,
        SizedBox(height: 10.0),
        nombre,
        SizedBox(height: 10.0),
        apellido,
        SizedBox(height: 10.0),
        email,
        registrar],
      ),    
    );

    

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: body,
      
    );
  }
}
