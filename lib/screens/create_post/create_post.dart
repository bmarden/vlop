import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("My Create Post Page"),
    );
  }
}
