import 'package:flutter/material.dart';
import 'package:story_app/data/model/user_profile.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/story_api_service.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/static/auth_status.dart';

class StoryAuthProvider extends ChangeNotifier {
  final StoryApiService storyApiService;
  final SharedPreferencesService prefService;
  final FirebaseAuthService? firebaseAuthService;

  StoryAuthProvider({
    required this.storyApiService,
    required this.prefService,
    this.firebaseAuthService,
  });

  String? _message;
  String? get message => _message;

  AuthStatus _authStatus = Unauthenticated();
  AuthStatus get authStatus => _authStatus;

  Future<void> registerUser(String name, String email, String password) async {
    _authStatus = CreatingAccount();
    notifyListeners();
    try {
      await storyApiService.registerUser(name, email, password);
      //await firebaseAuthService?.createUser(name, email, password);
      _authStatus = AccountCreated();
      _message = "Create account is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    _authStatus = Authenticating();
    notifyListeners();
    try {
      final result = await storyApiService.loginUser(email, password);
      //final userCredential = await firebaseAuthService?.signInUser(email, password);
      final profile = UserProfile.fromJson(result.loginResult.toJson());
      await prefService.saveUserValue(profile);
      _authStatus = Authenticated(profile);
      _message = "Sign in is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    _authStatus = SigningOut();
    notifyListeners();
    try {
      await prefService.removeUserValue();
      _authStatus = Unauthenticated();
      _message = "Sign out is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }

  Future<void> loaduser() async {
    _authStatus = Authenticating();
    notifyListeners();
    try {
      final userProfile = await prefService.getUserValue();
      await Future.delayed(Duration(seconds: 1));
      if (userProfile != null) {
        _authStatus = Authenticated(userProfile);
        _message = "Load user is success";
      } else {
        _authStatus = Unauthenticated();
      }
    } catch (e) {
      _message = e.toString();
      _authStatus = Error(_message!);
    }
    notifyListeners();
  }
}
