import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/model/user_profile.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/data/services/story_auth_service.dart';
import 'package:story_app/static/auth_state.dart';

class AppAuthProvider extends ChangeNotifier {
  final StoryAuthService storyAuthService;
  final FirebaseAuthService? firebaseAuthService;
  final SharedPreferencesService prefService;

  AppAuthProvider({
    required this.storyAuthService,
    required this.prefService,
    this.firebaseAuthService,
  });

  AuthState _authState = AuthUnauthenticated();
  AuthState get authState => _authState;

  UserProfile? get userProfile => (_authState is AuthAuthenticated)
      ? (_authState as AuthAuthenticated).user
      : null;

  Future<void> registerUser(String name, String email, String password) async {
    _authState = AuthCreatingAccount();
    notifyListeners();
    try {
      await storyAuthService.registerUser(name, email, password);
      //await firebaseAuthService?.createUser(name, email, password);
      _authState = AuthAccountCreated();
      notifyListeners();
    } on HttpException catch (e) {
      _authState = AuthError(e: e, message: e.message);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _authState = AuthError(e: e, message: "Failed creating account");
      notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password) async {
    _authState = AuthAuthenticating();
    notifyListeners();
    try {
      final result = await storyAuthService.loginUser(email, password);
      //final userCredential = await firebaseAuthService?.signInUser(email, password);
      final user = UserProfile.fromJson(result.loginResult.toJson());
      await prefService.saveUserValue(user);
      _authState = AuthAuthenticated(user: user, message: result.message);
      notifyListeners();
    } on HttpException catch (e) {
      _authState = AuthError(e: e, message: e.message);
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _authState = AuthError(e: e, message: "Login user fail");
      notifyListeners();
    }
  }

  Future<void> logoutUser() async {
    _authState = AuthSigningOut();
    notifyListeners();
    try {
      await prefService.removeUserValue();
      _authState = AuthUnauthenticated();
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _authState = AuthError(e: e, message: "Logout user fail");
      notifyListeners();
    }
  }

  Future<void> loaduser() async {
    _authState = AuthAuthenticating();
    notifyListeners();
    try {
      final userProfile = await prefService.getUserValue();
      await Future.delayed(Duration(seconds: 1));
      if (userProfile != null) {
        _authState = AuthAuthenticated(user: userProfile);
      } else {
        _authState = AuthUnauthenticated();
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error $e");
      _authState = AuthError(e: e, message: "Load user fail");
      notifyListeners();
    }
  }
}
