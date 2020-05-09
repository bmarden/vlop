import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/utilities/widgets.dart';
import 'package:vlop/services/database.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Upload extends StatelessWidget {
  final Photo photo;
  final String userId;

  Upload({this.photo, this.userId});

  Future<void> _addImageData() async {
    await DbService()
        .addImageDataToCollections(photo, 'images/${photo.id}.png');
  }

  @override
  Widget build(BuildContext context) {
    var pr = ProgressDialog(
      context,
      type: ProgressDialogType.Download,
      isDismissible: true,
      showLogs: true,
    );
    pr.style(
      message: 'Uploading post',
      borderRadius: 10.0,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidget: CircularProgressIndicator(),
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    var _uploadTask;
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: Column(
        children: <Widget>[
          Image.file(
            photo.imageFile,
            width: 300,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Button(
                child: Text(
                  'Upload',
                ),
                onPressed: () async {
                  await pr.show();
                  _uploadTask = DbService().uploadTask(photo, userId);

                  await _uploadTask.events.listen((data) {
                    var event = data?.snapshot;
                    var progressPercent = event != null
                        ? event.bytesTransferred / event.totalByteCount
                        : 0.0;
                    pr.update(progress: progressPercent * 100);
                    if (_uploadTask.isComplete) {
                      pr.hide().whenComplete(() => print(pr.isShowing()));
                      _addImageData();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AfterUpload()));
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AfterUpload extends StatefulWidget {
  @override
  _AfterUploadState createState() => _AfterUploadState();
}

class _AfterUploadState extends State<AfterUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    'Upload Complete',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: FlareActor(
                  'assets/checkmark.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: 'go',
                ),
              ),
            ),
            Center(
              child: Button(
                child: Text('Return Home'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
