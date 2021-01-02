import 'package:firebase_auth/firebase_auth.dart';
import 'package:socgo/services/database_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      UserCredential cred = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User user = cred.user;
      await DatabaseService(uid: user.uid).updateUserData('New', 'User', DateTime(1990), false, false, "null", user.uid);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
