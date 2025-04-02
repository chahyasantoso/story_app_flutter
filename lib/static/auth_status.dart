sealed class AuthStatus {
  const AuthStatus();
}

class Unauthenticated extends AuthStatus {
  const Unauthenticated();
}

class CreatingAccount extends AuthStatus {
  const CreatingAccount();
}

class AccountCreated extends AuthStatus {
  const AccountCreated();
}

class Authenticating extends AuthStatus {
  const Authenticating();
}

class Authenticated extends AuthStatus {
  const Authenticated();
}

class SigningOut extends AuthStatus {
  const SigningOut();
}

class Error extends AuthStatus {
  final String message;
  const Error(this.message);
}
