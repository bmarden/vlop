import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/services/database.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var pics = Provider.of<List<Photo>>(context);
    pics.forEach((pic) => print(pic.id));
    return ListView(
      children: <Widget>[],
    );
  }
}
