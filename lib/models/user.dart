class User {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String phoneNumber;

  User({this.uid, this.displayName, this.email, this.photoUrl, this.phoneNumber});
}

class PeopleData {
  final String uid;
  final String name;
  final String sugars;
  final int strength;

  PeopleData({this.uid, this.name, this.sugars, this.strength});
}