import 'package:finapp/models/gastos-models.dart';
import 'package:finapp/models/ingreso-models.dart';
import 'package:finapp/tabs/gastos-tabs.dart';
import 'package:finapp/tabs/ingresos-tabs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

final ingresoReference = FirebaseDatabase.instance.reference().child('ingreso');
final gastosReference = FirebaseDatabase.instance.reference().child('gastos');

class HomePage extends StatefulWidget {
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Ingreso> ingreso;
  List<Gastos> gasto;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
     ingreso = new List();   

     gasto = new List();
    
   
  }


  Widget build(BuildContext context) {
    final TabController = new DefaultTabController(
      length: 2, //dos pestañas va tener
      child: new Scaffold(
        appBar: AppBar(
          title: new Text("Saldo: \$${_valorTotal(ingreso, gasto)}"),
          bottom: new TabBar(
            indicatorColor: Colors.orange,
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.add),
                text: "Ingresos",
              ),
              new Tab(
                icon: new Icon(Icons.child_care),
                text: "Gastos",
              )
            ],
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            new ListViewIngreso(), // revisar esta linea que no estoy segura
            new GastosTabs(),
          ],
        ),
      ),
    );
    return new MaterialApp(
      title: 'Tabs con flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabController,
    );
  }

  String _valorTotal(List<Ingreso> ingreso, List<Gastos> gasto) {
    double total = 0.0;
    double myDoubleIngreso;
    double myDoubleGasto;
    double totalGasto = 0.0;
    double totalIngreso = 0.0;

    for (int i = 0; i < ingreso.length; i++) {
      myDoubleIngreso = double.parse(ingreso[i].valor);
      totalIngreso = totalIngreso + myDoubleIngreso;
    }
    for (int i = 0; i < gasto.length; i++) {
      myDoubleGasto = double.parse(gasto[i].valor);
      totalGasto = totalGasto + myDoubleGasto;
    }

    total = totalIngreso - totalGasto;
    return total.toString();
  }
}
