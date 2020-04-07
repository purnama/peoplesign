class User {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;

  User({this.uid, this.displayName, this.email, this.photoUrl});
}

class UserData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  UserData({this.uid, this.name, this.sugars, this.strength});
}