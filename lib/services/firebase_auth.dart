import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_client/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<String> currentUserUid() async {
    User user = await _firebaseAuth.currentUser!;

    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = credential.user!;

    return user.uid;
  }

  Future<String> createUserWithEmailAndPassword({
    required String email, required String password
  }) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = credential.user!;

    return user.uid;
  }

  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser!;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = await _firebaseAuth.currentUser!;

    return user.emailVerified;
  }
}
