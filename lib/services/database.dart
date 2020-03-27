import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseService {
  // collection reference
  final CollectionReference peopleCollection =
  Firestore.instance.collection('peoples');

  final String uid;

  DatabaseService({this.uid});

  Future updateUserData(String name, Position position, DateTime clockIn,
      DateTime clockOut) async {
    print('test');
    return await peopleCollection.document(uid).setData({
      'name': name,
      'position': position,
      'clockIn': clockIn,
      'clockOut': clockOut,
    });
  }
}
