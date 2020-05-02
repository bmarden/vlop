import 'package:firebase_auth/firebase_auth.dart';
import 'package:vlop/models/user.dart';
import 'package:vlop/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user object based on the firebase user
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Attemps to sign in to FirebaseAuth anonymously
  // Temporary
  Future anonymousSignIn() async {
    try {
      var result = await _auth.signInAnonymously();
      var user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Provides updates to app of any user state changes
  Stream<User> get getUser {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebase(user));
  }

  // Create a new Firebase user
  Future registerNewUser(String email, String userName, String password) async {
    // Attempt to register new Firebase user
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var newUser = result.user;

      // If Firebase registration successful, register user in 'users' collection
      await DbService(uid: newUser.uid).updateUser(email, userName);
      return _userFromFirebase(newUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInUserWithEmail(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      var user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Log the current user out
  Future logout() async {
    return await _auth.signOut();
  }
}
