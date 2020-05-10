import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/screens/profile/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Gets a profile photo from Firebase
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
    return ClipOval(
      child: Image.asset(
        'assets/images/default.png',
        width: 100,
        height: 100,
        fit: BoxFit.fill,
        color: Colors.blueGrey[100],
      ),
    );
  }

  // _getProfilePictures() {

  // }

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
              child: StreamBuilder<List<Photo>>(
                stream: DbService(userName: userData.userName).userPosts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      itemCount: snapshot.data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl: snapshot.data[index]?.url,
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
