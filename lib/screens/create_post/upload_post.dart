import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/utilities/constants.dart';
import 'package:vlop/utilities/widgets.dart';

class Upload extends StatefulWidget {
  final Photo photo;
  final User user;
  Upload({Key key, this.photo, this.user}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://vlop-d2566.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String path = 'images/${widget.user.uid}/${widget.photo.id}.png';
    // String path = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(path).putFile(widget.photo.imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;
            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            return Column(
              children: <Widget>[
                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
                if (_uploadTask.isComplete)
                  Text("Upload Complete!"),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),
                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
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
            color: Colors.blue[700],
            onPressed: _startUpload,
          ),
        ],
      );
    }
  }
}
