import 'dart:async';

import 'package:finapp/models/gastos-models.dart';
import 'package:finapp/pages/gastos-page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GastosTabs extends StatefulWidget {
  GastosTabs({Key key}) : super(key: key);

  @override
  _GastosTabsState createState() => _GastosTabsState();
}

final gastosReference = FirebaseDatabase.instance.reference().child('gastos');

class _GastosTabsState extends State<GastosTabs> {
  List<Gastos> items;

  StreamSubscription<Event> _onGastosAdd;
  StreamSubscription<Event> _onGastosEdit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onGastosAdd = gastosReference.onChildAdded.listen(_onGastosAdded);
    _onGastosEdit = gastosReference.onChildAdded.listen(_onGastosEdited);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onGastosAdd.cancel();
    _onGastosEdit.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(
                    height: 1.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "total: \$${valorTotal(items)}",
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${items[position].descripcion}',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 21.0,
                            ),
                          ),
                          subtitle: Text(
                            '${items[position].valor.toString()}',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 21.0,
                            ),
                          ),

                          //  onTap: () => _navigateIngresoInformation(context, items[position]) //barra navegacion
                        ),
                      ),

                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            _deleteGastos(context, items[position], position),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _navigateToGastos(
                            context, items[position], position),
                      ),
                      //  IconButton(
                      //  icon: Icon(Icons.edit, color: Colors.red,),
                      // onPressed: ()=> _navigateToIngreso(context, items[position])),
                    ],
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () => _createNewGastos(context),
      ),
    );
  }

  void _onGastosAdded(Event event) {
    setState(() {
      items.add(new Gastos.fromSnapShop(event.snapshot));
    });
  }

  void _onGastosEdited(Event event) {
    var oldIngresoValue =
        items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldIngresoValue)] =
          new Gastos.fromSnapShop(event.snapshot);
    });
  }

  void _deleteGastos(BuildContext context, Gastos gastos, int position) async {
    await gastosReference.child(gastos.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _editGastos(BuildContext context, Gastos gastos) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GastosScreen(Gastos(null, '', ''))),
    );
  }

/**barra navegacion
  void  _navigateIngresoInformation(BuildContext context, Ingreso ingreso )async{
 //   await Navigator.push(context, 
   // MaterialPageRoute(builder: (context) => HomePage(ingreso)),
    //);

 

  }**/
  void _navigateToGastos(
      BuildContext context, Gastos gastos, int position) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GastosScreen(gastos)),
    );
  }

  void _createNewGastos(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GastosScreen(Gastos(null, '', ''))),
    );
  }

  String valorTotal(List<Gastos> lista) {
    double totalGastos = 0.0;
    double myDouble;
    for (int i = 0; i < lista.length; i++) {
      myDouble = double.parse(lista[i].valor);
      totalGastos = totalGastos + myDouble;
    }
    print(totalGastos);
    return totalGastos.toStringAsFixed(3);
  }
}
