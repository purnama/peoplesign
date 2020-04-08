import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peoplesign/models/people.dart';
import 'package:peoplesign/models/user.dart';

class DatabaseService {
  // collection reference
  final CollectionReference peopleCollection =
      Firestore.instance.collection('peoples');

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  final String uid;

  DatabaseService({this.uid});

  Future updatePeopleData(String name, Position position, DateTime clockIn,
      DateTime clockOut, String sugars, int strength) async {
    return await peopleCollection.document(uid).setData({
      'name': name,
      'position': position,
      'clockIn': clockIn,
      'clockOut': clockOut,
      'sugars': sugars,
      'strength': strength,
    });
  }

  Future updateUserData(User user) async {
    return await userCollection.document(uid).setData({
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'email': user.email,
    });
  }

  // poeple list from snapshot
  List<People> _peopleListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents
        .map((document) => People(
              name: document.data['name'] ?? '',
              position: document.data['position'],
              clockIn: document.data['clockIn'],
              clockOut: document.data['clockOut'],
              sugars: document.data['sugars'],
              strength: document.data['strength'],
            ))
        .toList();
  }

  // userData from snapshot
  PeopleData _peopleDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return PeopleData(
      uid: uid,
      name: documentSnapshot.data['name'],
      sugars: documentSnapshot.data['sugars'],
      strength: documentSnapshot.data['strength'],
    );
  }

  // get peoples stream
  Stream<List<People>> get peoples {
    return peopleCollection.snapshots().map(_peopleListFromSnapshot);
  }

  // get people document stream
  Stream<PeopleData> get peopleData {
    return peopleCollection
        .document(uid)
        .snapshots()
        .map(_peopleDataFromSnapshot);
  }
}
