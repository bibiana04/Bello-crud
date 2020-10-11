import 'package:finapp/home-page.dart';
import 'package:finapp/login-state.dart';
import 'package:finapp/pages/ingreso-pages.dart';
import 'package:finapp/pages/login-page.dart';
import 'package:finapp/tabs/ingresos-tabs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      //builder: (BuildContext context)=> LoginState(),
      create: (_) => LoginState.instance(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/home': (BuildContext context) => HomePage(),
          '/ingreso': (BuildContext context) => ListViewIngreso(),
          
        },
        debugShowCheckedModeBanner: false,
       
        home: Consumer(
          builder: (context, LoginState authService, _) {
            switch (authService.status) {
              case AuthStatus.Uninitialized:
                return Text('Cargando');
              case AuthStatus.Authenticated:
                return HomePage();
              case AuthStatus.Authenticating:
                return LoginPage();
              case AuthStatus.Unauthenticated:
                return LoginPage();
            }
            return null;
          },
        )
      ),
    );
  }
}