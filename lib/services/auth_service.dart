import 'package:firebase_auth/firebase_auth.dart';
import 'package:vlop/models/user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user object based on the firebase user
  User _userFromFirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Attemps to sign in to FirebaseAuth anonymously
  // Temporary
  Future anonymousSignIn() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
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
  Future registerNewUser(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser newUser = result.user;
      return _userFromFirebase(newUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInUserWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
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
