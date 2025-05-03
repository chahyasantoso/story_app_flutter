import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;

  FirebaseAuthService(
    FirebaseAuth? auth,
  ) : _auth = auth ??= FirebaseAuth.instance;

  Future<UserCredential> createUser(
      String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(name);
      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "email-already-in-use" =>
          "There already exists an account with the given email address.",
        "invalid-email" => "The email address is not valid.",
        "operation-not-allowed" => "Server error, please try again later.",
        "weak-password" => "The password is not strong enough.",
        _ => "Register failed. Please try again.",
      };
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<UserCredential> signInUser(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } on FirebaseAuthException catch (e) {
      final errorMessage = switch (e.code) {
        "invalid-email" => "The email address is not valid.",
        "user-disabled" => "User disabled.",
        "user-not-found" => "No user found with this email.",
        "wrong-password" => "Wrong email/password combination.",
        _ => "Login failed. Please try again.",
      };
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception(e);
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed. Please try again.");
    }
  }

  Future<User?> userChanges() => _auth.userChanges().first;
}
