import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/screens/profile/upload_profile_photo.dart';

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  Photo _profilePhoto;

  /// Get image from the gallery
  Future<void> _openGallery(BuildContext context, String userUid) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _profilePhoto = Photo(
        imageFile: picture,
      );
    });
  }

  /// Take new picture from camera
  Future<void> _openCamera(BuildContext context, String userUid) async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _profilePhoto = Photo(
        imageFile: picture,
      );
    });
  }

  Future<void> _cropPhoto() async {
    var cropped = await ImageCropper.cropImage(
      sourcePath: _profilePhoto.imageFile.path,
    );
    setState(() {
      _profilePhoto.imageFile = cropped ?? _profilePhoto.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Profile Photo'),
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
              onPressed: () => _openCamera(context, user.uid),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _openGallery(context, user.uid),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_profilePhoto?.imageFile != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
              child: Image.file(
                _profilePhoto.imageFile,
                height: 400.0,
              ),
            ),
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
                    setState(() => _profilePhoto = null);
                  },
                ),
              ],
            ),
            Upload(photo: _profilePhoto, user: user),
          ],
        ],
      ),
    );
  }
}
