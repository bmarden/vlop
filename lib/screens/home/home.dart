import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/screens/home/post_feed.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:vlop/screens/create_post/create_post.dart';
import 'package:vlop/services/database.dart';
import 'package:vlop/utilities/constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // An instance of AuthService that gives access to FirebaseAuth services to logout user
  final AuthService _auth = AuthService();
  final DbService _db = DbService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Photo>>.value(
      value: _db.photoStream,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Vlop',
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.center,
                ),
                decoration: kBoxGradient,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                onTap: () async {
                  Navigator.pop(context);
                  await _auth.logout();
                },
                title: Text(
                  'Sign out',
                  style: kLabelStyle,
                ),
              ),
            ],
          ),
        ),
        body: Feed(),
      ),
    );
  }
}
