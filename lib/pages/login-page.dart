import 'package:finapp/login-state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    final authservices =  Provider.of<LoginState>(context);
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Entre lk'),
          onPressed: () async{
            await authservices.googleSignIn();
          })
        ),
      );
    
  }
}
