import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vlop/models/user.dart';

class DbService {
  final String uid;
  DbService({this.uid});

  // Instantiate a reference to Firebase collection
  final CollectionReference _userCollection =
      Firestore.instance.collection('users');

  Future updateUser(String email, String userName) async {
    return await _userCollection.document(uid).setData({
      'email': email,
      'userName': userName,
    });
  }
}
