import 'package:flutter/material.dart';
import 'package:vlop/screens/profile/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<Widget> _downloadProfilePhoto(
      BuildContext context, String userId) async {
    final path = 'profile_images/${userId}.png';
    var picUrl = await DbService(uid: userId).downloadTask(path);
    if (picUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(picUrl),
        radius: 100,
      );
    }
    return CircleAvatar(
      backgroundImage: AssetImage('assets/images/default.jpg'),
      radius: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future: _downloadProfilePhoto(context, user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data;
                }
                return Text('no image');
              },
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
                    child: FutureBuilder(
                      // future: _DownloadUserPhotos(context, user.uid,index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data;
                        }
                        return Text('no image');
                      },
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
