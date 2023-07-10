abstract class AuthenticationApi {
  getFirebaseAuth();

  Future<String> currentUserUid();

  Future<void> signOut();

  Future<String> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password
  });
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}
