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
      Firestore.instance.collection('imagesInfo');

  Future updateUser(String email, String userName) async {
    return await _userCollection.document(uid).setData({
      'email': email,
      'userName': userName,
    });
  }

  Future<void> addUserPost(String userId, String picId) {
    return _userCollection.document(userId).setData({
      'postIds': FieldValue.arrayUnion([picId])
    }, merge: true);
  }

  /// Returns a stream of UserData if a user is logged in
  Stream<UserData> get userStream {
    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
        // Get the reference to the currently logged in user
        final DocumentReference _userDoc =
            Firestore.instance.document('users/${user.uid}');

        // Return a stream of data that can be used for user information in the app
        return _userDoc
            .snapshots()
            .map((snaps) => UserData.fromMap(snaps.data));
      } else {
        return Stream<UserData>.value(null);
      }
    });
  }

  // Get a single document by user id
  Future<UserData> getUserDoc() {
    return _userCollection
        .document(uid)
        .get()
        .then((snap) => UserData.fromMap(snap.data));
  }

  StorageUploadTask uploadTask(Photo pic, String userId) {
    // Save the postId to the user's Posts array in their document
    addUserPost(userId, pic.id);
    String path = 'images/${userId}/${pic.id}.png';
    return _storage.ref().child(path).putFile(pic.imageFile);
  }
}
