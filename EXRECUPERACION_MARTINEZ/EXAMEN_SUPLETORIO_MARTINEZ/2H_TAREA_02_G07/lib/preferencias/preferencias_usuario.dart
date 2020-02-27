

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciaUsuario{

  static final PreferenciaUsuario _instancia = new PreferenciaUsuario._internal();

  factory PreferenciaUsuario(){
    return _instancia;
  }

  PreferenciaUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async{
    this._prefs = await SharedPreferences.getInstance();
  }


  //GET Y SET del usuario
  get usuario{
    return _prefs.getString('usuario') ?? 'no-identificado';
  }

  set usuario(String value){
    _prefs.setString('usuario', value);
  }

  get clave{
    return _prefs.getString('clave') ?? 'no-registrado';
  }

  set clave(String value){
    _prefs.setString('clave', value);
  }

}