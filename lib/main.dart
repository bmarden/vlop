import 'package:flutter/material.dart';
import 'package:vlop/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:vlop/utilities/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().getUser,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: kThemeData,
        home: Wrapper(),
      ),
    );
  }
}
