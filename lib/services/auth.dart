import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtubelikeapp/model/user.dart';
import 'package:youtubelikeapp/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      String defaultUrl = await FirebaseStorage.instance.ref().child("default.png").getDownloadURL();
      await DatabaseService(uid: user.uid).updateUserData('initial name','please input your profile',defaultUrl);
      
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString);
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

}