import 'package:flutter/material.dart';
import 'package:story_app/data/model/user_profile.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/static/auth_status.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  String? get message => _message;

  AuthStatus _authStatus = Unauthenticated();
  AuthStatus get authStatus => _authStatus;

  Future<void> createAccount(String name, String email, String password) async {
    _authStatus = CreatingAccount();
    notifyListeners();
    try {
      await _service.createUser(name, email, password);
      _authStatus = AccountCreated();
      _message = "Create account is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future<void> signInUser(String email, String password) async {
    _authStatus = Authenticating();
    notifyListeners();
    try {
      // sign in ke story api (ada service lain lagi)
      // kalo ok, lanjut ke firebase auth
      // on error, return error message

      final result = await _service.signInUser(email, password);
      final profile = UserProfile(
        userId: result.user?.uid ?? "",
        name: result.user?.displayName ?? "",
        token: "",
      );
      _authStatus = Authenticated(profile);
      _message = "Sign in is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future<void> signOutUser() async {
    _authStatus = SigningOut();
    notifyListeners();
    try {
      await _service.signOut();
      _authStatus = Unauthenticated();
      _message = "Sign out is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _authStatus = Unauthenticated();
    notifyListeners();
    try {
      final user = await _service.userChanges();
      if (user == null) return;

      final profile = UserProfile(
        userId: user.uid,
        name: user.displayName ?? "User",
        token: "",
      );
      _authStatus = Authenticated(profile);
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }
}
