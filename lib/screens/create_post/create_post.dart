import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:vlop/models/photo.dart';

class CreatePost extends StatefulWidget {
  // @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Photo _postPhoto;

  Future<void> _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (picture == null) {
      print('no image found');
      return;
    }
    setState(() {
      _postPhoto = Photo(picture);
    });
  }

  Future<void> _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _postPhoto = Photo(picture);
    });
  }

  Future<void> _cropPhoto() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _postPhoto.imageFile.path,
    );
    setState(() {
      _postPhoto.imageFile = cropped ?? _postPhoto.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 45.0),
              icon: Icon(Icons.camera),
              onPressed: () => _openCamera(context),
            ),
            IconButton(
              padding: EdgeInsets.only(left: 45.0),
              icon: Icon(Icons.photo_library),
              onPressed: () => _openGallery(context),
            )
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_postPhoto?.imageFile != null) ...[
            Image.file(_postPhoto?.imageFile),
            FlatButton(
              child: Icon(Icons.crop),
              onPressed: _cropPhoto,
            ),
            FlatButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                setState(() => _postPhoto = null);
              },
            ),
          ],
        ],
      ),
    );
  }
}
