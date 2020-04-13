import 'package:flutter/material.dart';
import 'package:vlop/services/auth_service.dart';

class Login extends StatefulWidget {
  // Declare the function from auth_view. Will be used to change to register screen
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // AuthService instance to get Firebase Auth access
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Log in"),
                    onPressed: () async {
                      // Await the anonymous sign in, print result of User if successful
                      dynamic result = await _auth.anonymousSignIn();
                      if (result == null) {
                        print("Failed to sign in");
                      } else {
                        print("signed in");
                        print(result);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
