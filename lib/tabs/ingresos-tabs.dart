import 'dart:async';

import 'package:finapp/models/ingreso-models.dart';
import 'package:finapp/pages/ingreso-pages.dart';
import 'package:flutter/material.dart';
import 'package:finapp/main.dart';
import 'package:firebase_database/firebase_database.dart';

class ListViewIngreso extends StatefulWidget {
  IngresosTabs createState() => IngresosTabs();
}

final ingresoReference = FirebaseDatabase.instance.reference().child('ingreso');

class IngresosTabs extends State<ListViewIngreso> {
  List<Ingreso> items;

  StreamSubscription<Event> _onIngresoAdd;
  StreamSubscription<Event> _onIngresoEdit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onIngresoAdd = ingresoReference.onChildAdded.listen(_onIngresoAdded);
    _onIngresoEdit = ingresoReference.onChildAdded.listen(_onIngresoEdited);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onIngresoAdd.cancel();
    _onIngresoEdit.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //<dynamic> ingreso = ModalRoute.of(context).settings.arguments;

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
                            _deleteIngreso(context, items[position], position),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _navigateToIngreso(
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
        onPressed: () => _createNewIngreso(context),
      ),
    );
  }

  void _onIngresoAdded(Event event) {
    setState(() {
      items.add(new Ingreso.fromSnapShop(event.snapshot));
    });
  }

  void _onIngresoEdited(Event event) {
    var oldIngresoValue =
        items.singleWhere((product) => product.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldIngresoValue)] =
          new Ingreso.fromSnapShop(event.snapshot);
    });
  }

  void _deleteIngreso(
      BuildContext context, Ingreso ingreso, int position) async {
    await ingresoReference.child(ingreso.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _editIngreso(BuildContext context, Ingreso ingreso) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => IngresoScreen(Ingreso(null, '', ''))),
    );
  }

/**barra navegacion
  void  _navigateIngresoInformation(BuildContext context, Ingreso ingreso )async{
 //   await Navigator.push(context, 
   // MaterialPageRoute(builder: (context) => HomePage(ingreso)),
    //);

 

  }**/
  void _navigateToIngreso(
      BuildContext context, Ingreso ingreso, int position) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IngresoScreen(ingreso)),
    );
  }

  void _createNewIngreso(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => IngresoScreen(Ingreso(null, '', ''))),
    );
  }

  String valorTotal(List<Ingreso> lista) {
    double totalIngreso = 0.0;
    double myDouble;
    for (int i = 0; i < lista.length; i++) {
      myDouble = double.parse(lista[i].valor);
      totalIngreso = totalIngreso + myDouble;
    }
    print(totalIngreso);
    return totalIngreso.toStringAsFixed(3);
  }
}
