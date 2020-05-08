import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/screens/create_post/upload_post.dart';
import 'package:vlop/services/database.dart';
import 'package:vlop/utilities/constants.dart';
import 'package:vlop/utilities/widgets.dart';

class CreatePost extends StatefulWidget {
  // @override
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  Photo _postPhoto;

  /// Get image from the gallery

  Future<void> _pickImage(ImageSource source, String userUid,
      {BuildContext context}) async {
    final user = await DbService(uid: userUid).getUserDoc();

    var tags = [
      'fire',
      'best',
      'amazing',
    ];
    var picture = await ImagePicker.pickImage(source: source)
        .catchError((onError) => (print(onError)));

    setState(() {
      _postPhoto = Photo(
        id: Uuid().v1(),
        imageFile: picture,
        userOwner: user.userName,
        tags: tags,
      );
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
    final user = Provider.of<User>(context);
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
              onPressed: () =>
                  _pickImage(ImageSource.camera, user.uid, context: context),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () =>
                  _pickImage(ImageSource.gallery, user.uid, context: context),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
              child: Image.file(
                _postPhoto.imageFile,
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
                    setState(() => _postPhoto = null);
                  },
                ),
              ],
            ),
            // Upload(photo: _postPhoto, user: user),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Button(
                  child: Text('Next'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PostOptions(photo: _postPhoto),
                      ),
                    );
                  },
                ),
              ],
            ),
            // PostOptions(photo: _postPhoto),
          ],
        ],
      ),
    );
  }
}

class PostOptions extends StatelessWidget {
  final Photo photo;

  PostOptions({this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Image.file(
                  photo.imageFile,
                  height: 120,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    maxLength: 250,
                    decoration: kPostInputDecoration('Enter a caption...'),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                width: 350,
                child: TextFormField(
                  decoration: kPostInputDecoration('Add tags...'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
