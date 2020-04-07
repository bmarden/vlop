class User {
  // Store the uid from Firebase
  final String uid;
  User({this.uid});
}

class UserData {
  final String userName;
  final String email;
  final String uid;

  UserData({this.userName, this.email, this.uid});
}
