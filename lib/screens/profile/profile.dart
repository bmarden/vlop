import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/screens/profile/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  Photo _profileImage;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              //backgroundImage: FileImage(_profileImage),

              child: Text('NO profile photo'),
            ),
            RaisedButton(
              child: Text('Upload Profile Photo'),
              onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TakePhoto(),
                    ),
                  );
                },
            ),
            Text(userData.userName),
            Container(
              height: 400,
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
