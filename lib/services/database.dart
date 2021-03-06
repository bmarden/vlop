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

  Future<void> addProfilePicUrlToUserData(String userId, String path) async {
    var url = await _storage.ref().child(path).getDownloadURL();
    return _userCollection.document(userId).setData({
      'profileUrl': url,
    }, merge: true).catchError((e) => print(e.message));
  }

  /// Add data about image to imageData collection
  Future<void> addImageDataToCollections(Photo img, String path) async {
    var downloadUrl = await _storage.ref().child(path).getDownloadURL();
    await _addTagListToCollection(img.tags);
    return _imgCollection.document(img.id).setData({
      'userOwner': img.userOwner,
      'ownerId': img?.ownerId,
      // 'ownerProfilePic': img?.ownerProfilePic,
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
            .map((snaps) => UserData.fromFirestore(snaps));
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
        .then((snap) => UserData.fromFirestore(snap));
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
    try {
      var query = await _userCollection
          .where('userName', isEqualTo: userName)
          .getDocuments();
      return query.documents.single.documentID;
    } catch (e) {
      print(e.message);
    }
    return '';
  }

  /// Upload Image to Firebase storage and store Image Data in Firestore
  StorageUploadTask uploadTask(Photo img, String userId, bool postImg) {
    // If postImg true, save the Photo to the images/ path in Firebase storage
    if (postImg) {
      // Save the postId to the user's Posts array in their document
      _addPostToUserData(userId, img.id);
      return _storage
          .ref()
          .child('images/${img.id}.png')
          .putFile(img.imageFile);
    } else {
      // if postImg false, save image to profile_images/ path in Firebase storage.
      return _storage
          .ref()
          .child('profile_images/${userId}.png')
          .putFile(img.imageFile);
    }
  }

  /// Get a single URL from Firebase storage based on a path
  Future getDownloadURLFromFirebase(String path) async {
    try {
      var result = await _storage.ref().child(path).getDownloadURL();
      return result;
    } catch (e) {
      print('User doesn\'t have profile image, or the url is bad');
      return null;
    }
  }

  /// Stream of ImageData from Firestore, filtered by a user name
  Stream<List<Photo>> get userPosts {
    var photos = _imgCollection
        .where('userOwner', isEqualTo: userName)
        .snapshots()
        .map((snapshots) => snapshots.documents
            .map((snap) => Photo.fromFirestore(snap))
            .toList());
    return photos;
  }

  /// Gets a list of ImageData from Firestore which referenced photos. Future version of userPosts
  Future<List<Photo>> getUserPosts() async {
    try {
      var doc = await _userCollection
          .document(uid)
          .get()
          .then((doc) => UserData.fromFirestore(doc));
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
