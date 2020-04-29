import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String id;
  final String userOwner;
  final List<String> tags;
  File imageFile;
  Photo({this.imageFile, this.userOwner, this.tags, this.id});

  factory Photo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Photo(
      id: doc.documentID,
      userOwner: data['userOwner'] ?? '',
    );
  }
}
