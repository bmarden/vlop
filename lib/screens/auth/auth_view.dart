import 'package:flutter/material.dart';
import 'package:vlop/screens/auth/login.dart';
import 'package:vlop/screens/auth/register.dart';

class AuthSelect extends StatefulWidget {
  @override
  _AuthSelect createState() => _AuthSelect();
}

class _AuthSelect extends State<AuthSelect> {
  // Selecter, determines which screen to show
  bool register = false;

  // This function will give a way to switch between the login and register screens
  // within each of those classes
  void toggleView() {
    // When function is called, simply toggle boolean
    setState(() => register = !register);
  }

  @override
  Widget build(BuildContext context) {
    //if (register) {
    //  return Register(toggleView: toggleView);
    //} else {
    //  return Login(toggleView: toggleView);
    // }
    // Only return to Login view for now
    return Register();
  }
}
