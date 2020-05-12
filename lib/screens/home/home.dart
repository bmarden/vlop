import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/screens/home/post_feed.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:vlop/screens/create_post/create_post.dart';
import 'package:vlop/services/database.dart';
import 'package:vlop/utilities/constants.dart';
import 'package:vlop/screens/profile/profile.dart';

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
        extendBody: true,
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
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
          elevation: 8.0,
          shape: CircularNotchedRectangle(),
          notchMargin: 4.0,
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
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
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
                decoration: kBoxGradient,
              ),
              ListTile(
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                title: Text(
                  'Profile Page',
                  style: kLabelStyle,
                ),
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
