class User {
  // Store the uid from Firebase
  final String uid;
  User({this.uid});
}

class UserData {
  final String userName;
  final String email;
  final List<dynamic> postIds;
  final List<dynamic> likedTags;
  final String profileUrl;

  UserData({
    this.userName,
    this.email,
    this.postIds,
    this.likedTags,
    this.profileUrl,
  });

  factory UserData.fromMap(Map data) {
    return UserData(
      email: data['email'] ?? '',
      userName: data['userName'] ?? '',
      postIds: data['postIds'] as List ?? [],
      likedTags: data['likedTags'] as List ?? [],
      profileUrl: data['profileUrl'] ?? '',
    );
  }
}
