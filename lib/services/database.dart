import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vlop/models/photo.dart';
import 'package:vlop/models/user.dart';
import 'dart:async';

class DbService {
  final String uid;
  final String userName;
  DbService({this.uid, this.userName});

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

  // Instantiate reference to Firebase tags collection
  final CollectionReference _tagCollection =
      Firestore.instance.collection('tags');

  Future updateUser(String email, String userName, List<dynamic> tags) async {
    return await _userCollection.document(uid).setData({
      'email': email,
      'userName': userName,
      'likedTags': tags,
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
    await _addTagListToCollection(img.tags);
    return _imgCollection.document(img.id).setData({
      'userOwner': img.userOwner,
      'tags': FieldValue.arrayUnion(img.tags),
      'url': downloadUrl,
      'path': path,
      'caption': img.caption,
    }).catchError((e) => print(e.message));
  }

  /// Add the list of tags to the correct collection
  Future<void> _addTagListToCollection(List<dynamic> tags) async {
    for (var tag in tags) {
      await _tagCollection.document(tag).setData({
        'name': tag,
        'referenced': FieldValue.increment(1),
      }, merge: true);
    }
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

  /// Get a single document by user id
  Future<UserData> getUserDoc() {
    return _userCollection
        .document(uid)
        .get()
        .then((snap) => UserData.fromMap(snap.data));
  }

  /// Get a list of most referenced tags
  Future getMostCommonTags() async {
    var tagList = [];
    var query = await _tagCollection
        .orderBy('referenced', descending: true)
        .limit(10)
        .getDocuments();

    query.documents.forEach(
      (doc) => tagList.add(doc.data['name']),
    );

    return tagList;
  }

  /// Gets a user Id by their user name
  Future<String> getUserIdByUserName(String userName) async {
    var query = await _userCollection
        .where('userName', isEqualTo: userName)
        .getDocuments();
    return query.documents.single.documentID;
  }

  /// Upload Image to Firebase storage and store Image Data in Firestore
  StorageUploadTask uploadTask(Photo img, String userId) {
    var path = 'images/${img.id}.png';
    _addPostToUserData(userId, img.id);
    // Save the postId to the user's Posts array in their document
    return _storage.ref().child(path).putFile(img.imageFile);
  }

  // TODO Merge with uploadTask
  StorageUploadTask uploadTaskProfile(Photo img, String userId) {
    var path = 'profile_images/${userId}.png';
    return _storage.ref().child(path).putFile(img.imageFile);
  }

  // Gets single photo from firebase
  Future downloadTask(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<List<Photo>> get userPosts {
    var photos = _imgCollection
        .where('userOwner', isEqualTo: userName)
        .snapshots()
        .map((snapshots) => snapshots.documents
            .map((snap) => Photo.fromFirestore(snap))
            .toList());
    return photos;
  }

  // Get a list of postIds and then returns the urls from Firebase Storage
  Future<List<Photo>> getUserPosts() async {
    try {
      var doc = await _userCollection
          .document(uid)
          .get()
          .then((doc) => UserData.fromMap(doc.data));
      return _imgCollection
          .where('userOwner', isEqualTo: doc.userName)
          .getDocuments()
          .then((snapshots) => snapshots.documents
              .map((snap) => Photo.fromFirestore(snap))
              .toList());
    } catch (e) {
      print(e);
      return null;
    }
  }
}
