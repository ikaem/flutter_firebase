import "package:firebase_auth/firebase_auth.dart";
import "dart:async";

import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String?> loginWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(authCredential);

    final User? user = authResult.user;

    if (user != null) {
      return "$user";
    }

    return null;
  }

  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return credential.user?.uid;
    } on FirebaseAuthException {
      return null;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      print("this is credential: $credential");

      return credential.user?.uid;
    } catch (error) {
      print("this is error: $error");
      return null;
    }
    // } on FirebaseAuthException  {
    //   return null;
    // }
  }

  Future<bool> logoutUser() async {
    try {
      _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
