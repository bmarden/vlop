import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlop/models/photo.dart';

class CreatePost extends StatefulWidget {
  CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  var postPhoto;

  Future _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (picture == null) {
      print('no image found');
      return;
    }

    this.setState(() {
      postPhoto = Photo(picture);
    });
    Navigator.of(context).pop(); //pop alert dialog
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    this.setState(() {
      postPhoto = Photo(picture);
    });
    Navigator.of(context).pop(); //pop alert dialog
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Make a Choice'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                      child: Text('Camera'),
                      onTap: () {
                        _openCamera(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  Widget _viewImage(BuildContext context) {
    if (postPhoto == null) {
      return Text('No Image Selected');
    }

    return Image.file(
      postPhoto.photo,
      width: 200,
      height: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  child: Text('Add Image')),
              _viewImage(context)
            ],
          ),
        ),
      ),
    );
  }
}
