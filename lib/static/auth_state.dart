import 'package:story_app/data/model/user_profile.dart';

sealed class AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthCreatingAccount extends AuthState {}

class AuthAccountCreated extends AuthState {}

class AuthAuthenticating extends AuthState {}

class AuthSigningOut extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserProfile user;
  final String? message;
  AuthAuthenticated({required this.user, this.message});
}

class AuthError extends AuthState {
  final Object e;
  final String? message;
  AuthError({required this.e, this.message});
}
