class User {
  // Store the uid from Firebase
  final String uid;
  User({this.uid});
}

class UserData {
  final String userName;
  final String email;
  final List<String> postIds;

  UserData({this.userName, this.email, this.postIds});

  factory UserData.fromMap(Map data) {
    return UserData(
      email: data['email'] ?? '',
      userName: data['userName'] ?? '',
      postIds: data['postIds'] ?? '',
    );
  }
}
