import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  //final AuthService _auth = AuthService();

  //final DbService db = DbService();
  Photo _profilePhoto;

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);
    final DbService db = DbService();
    final user = db.getUserDoc();
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              //child: Text(),
            ),
            RaisedButton(
              child: Text("edit profile"),
              onPressed: () {},
            ),
            Text("Your Photos"),
            SizedBox(
              height: 200,
              width: 200,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(10, (index) {
                  return Center(
                    child: Text(
                      'Item $index',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
