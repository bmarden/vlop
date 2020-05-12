import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Photo {
  final String id;
  final String userOwner;
  final String ownerProfilePic;
  List<dynamic> tags;
  String caption;
  final String url;
  File imageFile;

  Photo({
    this.imageFile,
    this.userOwner,
    this.ownerProfilePic,
    this.tags,
    this.caption,
    this.id,
    this.url,
  });

  set setCaption(String c) {
    caption = c;
  }

  factory Photo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return Photo(
      id: doc.documentID,
      userOwner: data['userOwner'] ?? '',
      ownerProfilePic: data['ownerProfilePic'],
      tags: data['tags'] as List ?? [],
      caption: data['caption'] ?? '',
      url: data['url'] ?? '',
      imageFile: null,
    );
  }
}
