import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // Store the uid from Firebase
  final String uid;
  User({this.uid});
}

class UserData {
  final String id;
  final String userName;
  final String email;
  final List<dynamic> postIds;
  final List<dynamic> likedTags;
  final String profileUrl;

  UserData({
    this.id,
    this.userName,
    this.email,
    this.postIds,
    this.likedTags,
    this.profileUrl,
  });

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return UserData(
      id: doc.documentID,
      email: data['email'] ?? '',
      userName: data['userName'] ?? '',
      postIds: data['postIds'] as List ?? [],
      likedTags: data['likedTags'] as List ?? [],
      profileUrl: data['profileUrl'],
    );
  }
}
