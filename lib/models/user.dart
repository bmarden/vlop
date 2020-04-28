class User {
  // Store the uid from Firebase
  final String uid;
  User({this.uid});
}

class UserData {
  final String userName;
  final String email;

  UserData({this.userName, this.email});

  factory UserData.fromMap(Map data) {
    return UserData(
      email: data['email'] ?? '',
      userName: data['userName'] ?? '',
    );
  }
}
