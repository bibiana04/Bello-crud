import 'package:finapp/login-state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authservices = Provider.of<LoginState>(context);

    return Stack(
      children: <Widget>[
        FlareActor("assets/login.flr",
            fit: BoxFit.contain, animation: "success"),

        ////////////////////
        Scaffold(
          body: Center(
              child: RaisedButton(
                  child: Text('Entre lk'),
                  onPressed: () async {
                    await authservices.googleSignIn();
                  })),
        ),
      ],
    );
  }
}
