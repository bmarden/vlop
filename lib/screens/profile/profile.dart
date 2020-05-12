import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/screens/profile/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';
import 'package:vlop/utilities/loading.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Gets a profile photo from Firebase

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return userData == null
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('My Profile'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ProfilePic(userName: userData.userName),
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
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
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

class ProfilePic extends StatelessWidget {
  final String userName;
  final double radius;
  final Widget child;

  const ProfilePic({Key key, this.userName, this.radius = 75, this.child})
      : super(key: key);

  Future<Widget> _downloadProfilePhoto(
      BuildContext context, String userId) async {
    final id = await DbService().getUserIdByUserName(userId);
    final path = 'profile_images/${id}.png';
    print(path);
    var picUrl = await DbService(uid: id).downloadTask(path);
    if (picUrl != null) {
      return CircleAvatar(
          backgroundImage: NetworkImage(picUrl), radius: radius);
    }

    return CircleAvatar(
      backgroundImage: AssetImage('assets/images/default.png'),
      radius: radius,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _downloadProfilePhoto(context, userName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data;
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
