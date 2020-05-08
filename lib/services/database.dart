import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/models/user.dart';

class DbService {
  final String uid;
  DbService({this.uid});

  // Instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Instance of Firebase Storage
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://vlop-d2566.appspot.com');

  // Instantiate a reference to Firebase collection
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  // Instantiate a reference to Firebase image collection
  final CollectionReference _imgCollection =
      Firestore.instance.collection('imageData');

  Future updateUser(String email, String userName) async {
    return await _userCollection.document(uid).setData({
      'email': email,
      'userName': userName,
    });
  }

  /// Add imageData Id's to a user's postIds array
  Future<void> _addPostToUserData(String userId, String picId) {
    return _userCollection.document(userId).setData({
      'postIds': FieldValue.arrayUnion([picId])
    }, merge: true).catchError((e) => print(e.message));
  }

  /// Add data about image to imageData collection
  Future<void> addImageDataToCollections(Photo img, String path) async {
    var downloadUrl = await _storage.ref().child(path).getDownloadURL();
    return _imgCollection.document(img.id).setData({
      'userOwner': img.userOwner,
      'tags': FieldValue.arrayUnion(img.tags),
      'url': downloadUrl,
      'path': path,
    }).catchError((e) => print(e.message));
  }

  /// Returns a stream of UserData if a user is logged in
  Stream<UserData> get userStream {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        // Get the reference to the currently logged in user
        final _userDoc = Firestore.instance.document('users/${user.uid}');

        // Return a stream of data that can be used for user information in the app
        return _userDoc
            .snapshots()
            .map((snaps) => UserData.fromMap(snaps.data));
      } else {
        return Stream<UserData>.value(null);
      }
    });
  }

  Stream<List<Photo>> get photoStream {
    return _imgCollection.snapshots().map(
          (snaps) =>
              snaps.documents.map((doc) => Photo.fromFirestore(doc)).toList(),
        );
  }

  /// Download single image
  Future<Uint8List> downloadPhoto(String path) async {
    var MAX_SIZE = 5 * 1024 * 1024;
    return _storage.ref().child(path).getData(MAX_SIZE);
  }

  // Get a single document by user id
  Future<UserData> getUserDoc() {
    return _userCollection
        .document(uid)
        .get()
        .then((snap) => UserData.fromMap(snap.data));
  }

  /// Upload Image to Firebase storage and store Image Data in Firestore
  StorageUploadTask uploadTask(Photo img, String userId) {
    var path = 'images/${img.id}.png';
    _addPostToUserData(userId, img.id);
    // Save the postId to the user's Posts array in their document
    return _storage.ref().child(path).putFile(img.imageFile);
  }

  StorageUploadTask uploadTaskProfile(Photo img, String userId) {
    String path = 'profile_images/${userId}.png';
    return _storage.ref().child(path).putFile(img.imageFile);
  }

  Future<dynamic> downloadTask(String path) async {
    return await _storage.ref().child(path).getDownloadURL();
  }
} 
