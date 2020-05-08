import 'package:flutter/material.dart';
import 'package:vlop/screens/profile/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}
class _profilePageState extends State<profilePage> {
  
  Future<Widget> _DownloadProfilePhoto(BuildContext context,String userId) async{
    final path = 'profile_images/${userId}.png';
    Widget m;
    await DbService(uid: userId).downloadTask(path).then((curPhoto) {
      m = CircleAvatar(
        backgroundImage: NetworkImage(curPhoto.url),radius: 100,
        );
    }).catchError((e){
      print(e.error);
    });
    
    return m;
  }

  /*Future<Widget> _DownloadUserPhotos(BuildContext context,String userid,final index) async{
    UserData
    final path = 'images/'
    Widget m;
    await DbService(uid: userid).downloadTask(path).then((curPhoto) {
      m = CircleAvatar(
        backgroundImage: NetworkImage(curPhoto?.url),radius: 100,
        );
    }).catchError((e){
      print(e.error);
    });
    
    return m;
  }*/
 
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
          children: <Widget> [
            FutureBuilder(
              future: _DownloadProfilePhoto(context, user.uid),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.done){
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
                      builder: (context,snapshot){
                        if(snapshot.connectionState == ConnectionState.done){
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
