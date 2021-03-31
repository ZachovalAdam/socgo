import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socgo/services/database_service.dart';

class AuthenticationService {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ],
  );

  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    }
    await _firebaseAuth.signOut();
  }

  /*Future<void> signOutGoogle() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
  }*/

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signInGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final User user = userCredential.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      final isRegisteredInDBSnap = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

      if (!isRegisteredInDBSnap.exists) {
        await DatabaseService(uid: currentUser.uid)
            .updateUserData('', '', DateTime(2020), false, false, FirebaseAuth.instance.currentUser.photoURL, currentUser.uid);
      }

      return "Success";
    } catch (e) {
      print(e.message);
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = cred.user;
      await DatabaseService(uid: user.uid).updateUserData('', '', DateTime(2020), false, false, "null", user.uid);
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
