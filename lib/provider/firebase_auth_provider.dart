import 'package:flutter/material.dart';
import 'package:story_app/data/model/user_profile.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/static/auth_status.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  UserProfile? _profile;
  AuthStatus _authStatus = Unauthenticated();

  UserProfile? get profile => _profile;
  String? get message => _message;
  AuthStatus get authStatus => _authStatus;

  Future createAccount(String name, String email, String password) async {
    try {
      _authStatus = CreatingAccount();
      notifyListeners();

      await _service.createUser(name, email, password);

      _authStatus = AccountCreated();
      _message = "Create account is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future signInUser(String email, String password) async {
    try {
      _authStatus = Authenticating();
      notifyListeners();

      final result = await _service.signInUser(email, password);

      _profile = UserProfile(
        name: result.user?.displayName ?? "",
      );

      _authStatus = Authenticated();
      _message = "Sign in is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future signOutUser() async {
    try {
      _authStatus = SigningOut();
      notifyListeners();

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
      _profile = UserProfile(
        name: user.displayName ?? "User",
      );
      _authStatus = Authenticated();
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
      notifyListeners();
    }
  }
}
