import 'package:finapp/login-state.dart';
import 'package:finapp/models/ingreso-models.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';


class IngresoScreen extends StatefulWidget {
  final Ingreso ingreso;
  IngresoScreen(this.ingreso);
  _IngresoScreenState createState() => _IngresoScreenState();
}

final ingresoReference = FirebaseDatabase.instance.reference().child('usersI');
//final usersReference = FirebaseDatabase.instance.reference().child('users');
class _IngresoScreenState extends State<IngresoScreen> {
  List<Ingreso> items;
  Ingreso _ingreso;
  //Las variables que queremos captar la informacion;
  TextEditingController _descripcionController;
  TextEditingController _valorController;

  @override
  void initState() {
    super.initState();

    _descripcionController =
        new TextEditingController(text: widget.ingreso.descripcion);
    _valorController = new TextEditingController(text: widget.ingreso.valor);
    //  double val = _valorController.numberValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //para que no nos salga ña barra de simbolo amarillo
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Ingresos DB'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _descripcionController,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.deepOrangeAccent,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: 'Descripcion',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                //campo de valor
                TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.deepOrangeAccent,
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Valor',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                FlatButton(
                    onPressed: () {
                      var user = Provider.of<LoginState>(context).currentUser();
                     
                      if (widget.ingreso.id != null) {
                        ingresoReference.child(user.uid).child(widget.ingreso.id).set({
                          'descripcion': _descripcionController.text,
                          'valor': _valorController.text,
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        ingresoReference.push().set({
                          'descripcion': _descripcionController.text,
                          'valor': _valorController.text,
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: (widget.ingreso.id != null)
                        ? Text('Actualizar')
                        : Text('Agregar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
