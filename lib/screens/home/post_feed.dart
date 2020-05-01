import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlop/services/database.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final FirebaseStorage storage = FirebaseStorage(
      app: Firestore.instance.app,
      storageBucket: 'gs://vlop-d2566.appspot.com');

  Uint8List imgBytes;
  String errorMsg;

  _FeedState() {
    storage
        .ref()
        .child('images/cc2def50-8aa9-11ea-eb10-39c6ea3a47ae.png')
        .getData(10000000)
        .then((data) => setState(() {
              imgBytes = data;
            }))
        .catchError((e) => setState(() {
              errorMsg = e.error;
            }));
  }

  @override
  Widget build(BuildContext context) {
    var img = imgBytes != null
        ? Image.memory(
            imgBytes,
            fit: BoxFit.cover,
          )
        : Text(errorMsg != null ? errorMsg : "Loading...");
    return ListView(
      children: <Widget>[
        img,
      ],
    );
  }
}
