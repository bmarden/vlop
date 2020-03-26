import 'package:flutter/material.dart';
import 'package:vlop/screens/auth/auth_view.dart';
import 'package:vlop/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Stream coming from main of the current user
    final user = Provider.of<User>(context);

    // If the user object isn't null, then return the HomePage
    if (user != null) {
      return HomePage();
      // Otherwise send to AuthSelect screen
    } else {
      return AuthSelect();
    }
  }
}
