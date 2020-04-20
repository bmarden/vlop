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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePost(),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[500],
        elevation: 8.0,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {},
              ),
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
