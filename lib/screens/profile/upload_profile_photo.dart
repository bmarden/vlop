import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/utilities/widgets.dart';
import 'package:vlop/services/database.dart';

class Upload extends StatefulWidget {
  final Photo photo;
  final User user;
  Upload({Key key, this.photo, this.user}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  StorageUploadTask _uploadImage;

  void _startUpload() async {
    setState(() {
      _uploadImage =
          DbService().uploadTask(widget.photo, widget.user.uid, false);
    });
    await _uploadImage.onComplete;
    await _addPicUrl();
  }

  Future<void> _addPicUrl() async {
    await DbService().addProfilePicUrlToUserData(
        widget.user.uid, 'profile_images/${widget.user.uid}.png');
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadImage != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadImage.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;
            var progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0.0;
            return Column(
              children: <Widget>[
                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
                if (_uploadImage.isComplete)
                  Text('Upload Complete!'),
                if (_uploadImage.isInProgress) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.cancel),
                        onPressed: _uploadImage.cancel,
                      ),
                      FlatButton(
                        child: Icon(Icons.pause),
                        onPressed: _uploadImage.pause,
                      ),
                    ],
                  ),
                ] else ...[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                  ),
                ],
                if (_uploadImage.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadImage.resume,
                  ),
              ],
            );
          });
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Button(
            child: Text(
              'Upload',
            ),
            onPressed: _startUpload,
          ),
        ],
      );
    }
  }
}
