import 'package:flutter/material.dart';
import 'package:story_app/data/model/login_result.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/usecases/user_usecases.dart';
import 'package:story_app/static/auth_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class AppAuthProvider extends SafeChangeNotifier {
  final UserUsecases _userUsecase;

  AppAuthProvider(this._userUsecase);

  AuthState _authState = AuthUnauthenticated();
  AuthState get authState => _authState;

  LoginResult? get user =>
      (_authState is AuthAuthenticated)
          ? (_authState as AuthAuthenticated).user
          : null;

  Future<void> registerUser(String name, String email, String password) async {
    _authState = AuthCreatingAccount();
    notifyListeners();

    final result = await _userUsecase.registerUser(name, email, password);
    switch (result) {
      case DomainResultSuccess():
        _authState = AuthAccountCreated();
        notifyListeners();

      case DomainResultError(message: final message):
        _authState = AuthError(e: "error", message: message);
        notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password) async {
    _authState = AuthAuthenticating();
    notifyListeners();

    final result = await _userUsecase.loginUser(email, password);
    switch (result) {
      case DomainResultSuccess(data: final userEntity, message: final message):
        final user = LoginResult.fromEntity(userEntity);
        _authState = AuthAuthenticated(user: user, message: message);
        notifyListeners();

      case DomainResultError(message: final message):
        _authState = AuthError(e: "error", message: message);
        notifyListeners();
    }
  }

  Future<void> logoutUser() async {
    _authState = AuthSigningOut();
    notifyListeners();

    final result = await _userUsecase.logoutUser();
    switch (result) {
      case DomainResultSuccess():
        _authState = AuthUnauthenticated();
        notifyListeners();

      case DomainResultError(message: final message):
        _authState = AuthError(e: "error", message: message);
        notifyListeners();
    }
  }

  Future<void> loaduser() async {
    _authState = AuthAuthenticating();
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    final result = await _userUsecase.loadUser();
    switch (result) {
      case DomainResultSuccess(data: final userEntity):
        if (userEntity == null) {
          _authState = AuthUnauthenticated();
        } else {
          final user = LoginResult.fromEntity(userEntity);
          _authState = AuthAuthenticated(user: user);
        }
        notifyListeners();

      case DomainResultError(message: final message):
        debugPrint("Error $message");
        _authState = AuthError(e: "error", message: message);
        notifyListeners();
    }
  }
}
