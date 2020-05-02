import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:vlop/models/photo.dart';

class CreatePost extends StatefulWidget {
  // @override
  @override
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
    var cropped = await ImageCropper.cropImage(
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
        title: Text('Create Post'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 5.0),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () => _openCamera(context),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _openGallery(context),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_postPhoto?.imageFile != null) ...[
            Image.file(_postPhoto.imageFile),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
            ),
          ],
        ],
      ),
    );
  }
}
