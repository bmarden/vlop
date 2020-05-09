import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/utilities/widgets.dart';
import 'package:vlop/services/database.dart';

class Upload extends StatefulWidget {
  final Photo photo;
  final String userId;
  Upload({Key key, this.photo, this.userId}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  StorageUploadTask _uploadImage;

  void _startUpload() async {
    setState(() {
      _uploadImage = DbService().uploadTask(widget.photo, widget.userId);
    });
    await _uploadImage.onComplete;
    await _addImageData();
  }

  Future<void> _addImageData() async {
    await DbService().addImageDataToCollections(
        widget.photo, 'images/${widget.photo.id}.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: Column(
        children: <Widget>[
          Image.file(widget.photo.imageFile),
          _uploadImage == null
              ? Row(
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
                )
              : StreamBuilder<StorageTaskEvent>(
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
                        Text(
                          '${(progressPercent * 100).toStringAsFixed(0)}% ',
                          style: Theme.of(context).textTheme.headline3,
                        ),
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
                  },
                ),
        ],
      ),
    );
  }
}
