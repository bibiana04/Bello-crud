import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class Ingreso {
  String _id;
  String _descripcion;
  //primero probar con el string para no estar jodiendo con el int y despues si a complicarse la vida
  String _valor;

  Ingreso(
    this._id, 
    this._descripcion, 
    this._valor );

  Ingreso.map(dynamic obj){
    this._descripcion = obj['descripcion'];
    this._valor = obj['valor'];
  }
  String get id => _id;
  String get descripcion => _descripcion; 
  //mirar esta linea
  String get valor => _valor;
  set valor(String value){
    _valor = value;
  }


  Ingreso.fromSnapShop(DataSnapshot snapshot){
    _id = snapshot.value['id'];
    _descripcion = snapshot.value['descripcion'];
    _valor = snapshot.value['valor'];
  }
  String toString() {
    return 'Ingreso{_id: $id, _descripcion:$descripcion._valor: $valor}';
  }

}