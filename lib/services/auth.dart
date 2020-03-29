import 'package:firebase_auth/firebase_auth.dart';
import 'package:peoplesign/models/user.dart';
import 'package:peoplesign/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) =>
      user != null ? User(uid: user.uid) : null;

  // auth change user stream
  Stream<User> get user => _auth.onAuthStateChanged
      .map((FirebaseUser user) => _userFromFirebaseUser(user));

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult authResult = await _auth.signInAnonymously();
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData('New people', null, null, null, '0', 100);

      return _userFromFirebaseUser(firebaseUser);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
}
