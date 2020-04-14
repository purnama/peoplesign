import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:peoplesign/models/user.dart';
import 'package:peoplesign/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final TwitterLogin _twitterLogin =
  TwitterLogin(consumerKey: 'xxx', consumerSecret: 'xxx');

  static String actualCode;

  // create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) =>
      user != null
          ? User(
          uid: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoUrl,
          phoneNumber: user.phoneNumber)
          : null;

  // auth change user stream
  Stream<User> get user =>
      _auth.onAuthStateChanged
          .map((FirebaseUser user) => _userFromFirebaseUser(user));

  // sign in anon
  Future<User> signInAnon() async {
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
  Future<User> signInWithEmailAndPassword(String email, String password) async {
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
  Future<User> registerWithEmailAndPassword(String email,
      String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: firebaseUser.uid)
          .updatePeopleData('New people', null, null, null, '0', 100);

      User userFromFirebaseUser = _userFromFirebaseUser(firebaseUser);

      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(userFromFirebaseUser);

      return userFromFirebaseUser;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // sign in with google
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      AuthResult authResult = await _auth.signInWithCredential(authCredential);
      FirebaseUser firebaseUser = authResult.user;
      User userFromFirebaseUser = _userFromFirebaseUser(firebaseUser);
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(userFromFirebaseUser);
      return userFromFirebaseUser;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // sign in with facebook
  Future<User> signInWithFacebook() async {
    try {
      final FacebookLoginResult facebookLogin =
      await _facebookLogin.logIn(['email']);
      final AuthCredential authCredential = FacebookAuthProvider.getCredential(
          accessToken: facebookLogin.accessToken.token);
      AuthResult authResult = await _auth.signInWithCredential(authCredential);
      FirebaseUser firebaseUser = authResult.user;
      User userFromFirebaseUser = _userFromFirebaseUser(firebaseUser);
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(userFromFirebaseUser);
      return userFromFirebaseUser;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // sign in with twitter
  Future<User> signInWithTwitter() async {
    try {
      final TwitterLoginResult twitterLoginResult =
      await _twitterLogin.authorize();
      final AuthCredential authCredential = TwitterAuthProvider.getCredential(
          authToken: twitterLoginResult.session.token,
          authTokenSecret: twitterLoginResult.session.secret);
      AuthResult authResult = await _auth.signInWithCredential(authCredential);
      FirebaseUser firebaseUser = authResult.user;
      User userFromFirebaseUser = _userFromFirebaseUser(firebaseUser);
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(userFromFirebaseUser);
      return userFromFirebaseUser;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // sign in with phone number
  Future<User> signInWithPhoneNumber(String smsCode) async {
    try {
      AuthCredential authCredential = PhoneAuthProvider.getCredential(
          verificationId: actualCode, smsCode: smsCode);

      AuthResult authResult = await _auth
          .signInWithCredential(authCredential);
      FirebaseUser firebaseUser = authResult.user;
      User userFromFirebaseUser = _userFromFirebaseUser(firebaseUser);
      await DatabaseService(uid: firebaseUser.uid)
          .updateUserData(userFromFirebaseUser);
      return userFromFirebaseUser;
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // verify phone number
  Future<void> verifyPhoneNumber(String phoneNumber, Function verifyFunction) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          /*AuthResult authResult =
          await _auth.signInWithCredential(authCredential);
          FirebaseUser firebaseUser = authResult.user;
          userFromFirebaseUser = _userFromFirebaseUser(firebaseUser);
          await DatabaseService(uid: firebaseUser.uid)
              .updateUserData(userFromFirebaseUser);*/
          print('verification completed');
        },
        verificationFailed: (AuthException authException) {
          if (authException.message.contains('not authorized'))
            print('App not authroized');
          else if (authException.message.contains('Network'))
            print('Please check your internet connection and try again');
          else
            print('Something has gone wrong, please try later ' +
                authException.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          actualCode = verificationId;
          verifyFunction(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          actualCode = verificationId;
        },
      );
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
