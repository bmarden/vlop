import 'package:flutter/material.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:vlop/screens/create_post/create_post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // An instance of AuthService that gives access to FirebaseAuth services to logout user
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: FaIcon(FontAwesomeIcons.plus),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreatePost(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Sign out"),
              // Using the AuthService to sign the current user out of Firebase
              onPressed: () async {
                await _auth.logout();
              },
            )
          ],
        ),
      ),
    );
  }
}
