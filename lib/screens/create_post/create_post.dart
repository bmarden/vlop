import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlop/models/photo.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  List<Photo> imageFiles = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[Text('Hello World')],
          ),
        ),
      ),
    );
  }
}
