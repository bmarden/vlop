import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Photo {
  final String id;
  final String userOwner;
  final List<dynamic> tags;
  final String url;
  File imageFile;

  Photo({this.imageFile, this.userOwner, this.tags, this.id, this.url});

  factory Photo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Photo(
      id: doc.documentID,
      userOwner: data['userOwner'] ?? '',
      tags: data['tags'] as List ?? [],
      url: data['url'],
      imageFile: null,
    );
  }
}
