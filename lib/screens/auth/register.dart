import 'package:flutter/material.dart';
import 'package:vlop/services/auth_service.dart';

class Register extends StatefulWidget {
  // Declare the function from auth_view. Will be used to change to login screen
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: _auth.anonymousSignIn,
        ),
      ),
    );
  }
}
