import 'dart:io';
import 'dart:typed_data';
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
      tags: data['tags'] as List ?? [],
      imageFile: data['file'],
    );
  }
}

class FeedPhoto {
  Uint8List image;

  FeedPhoto({this.image});
}
