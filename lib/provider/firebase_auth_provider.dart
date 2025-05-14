import 'package:story_app/data/model/user_profile.dart';
import 'package:story_app/data/services/firebase_auth_service.dart';
import 'package:story_app/static/auth_state.dart';
import 'package:story_app/widget/safe_change_notifier.dart';

class FirebaseAuthProvider extends SafeChangeNotifier {
  final FirebaseAuthService _service;

  FirebaseAuthProvider(this._service);

  String? _message;
  String? get message => _message;

  AuthState _authState = AuthUnauthenticated();
  AuthState get authState => _authState;

  Future<void> createAccount(String name, String email, String password) async {
    _authState = AuthCreatingAccount();
    notifyListeners();
    try {
      await _service.createUser(name, email, password);
      _authState = AuthAccountCreated();
      _message = "Create account is success";
    } catch (e) {
      _message = e.toString();
      _authState = AuthError(e: e, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> signInUser(String email, String password) async {
    _authState = AuthAuthenticating();
    notifyListeners();
    try {
      final result = await _service.signInUser(email, password);
      final profile = UserProfile(
        userId: result.user?.uid ?? "",
        name: result.user?.displayName ?? "",
        token: "",
      );
      _authState = AuthAuthenticated(user: profile);
    } catch (e) {
      _authState = AuthError(e: e, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> signOutUser() async {
    _authState = AuthSigningOut();
    notifyListeners();
    try {
      await _service.signOut();
      _authState = AuthUnauthenticated();
    } catch (e) {
      _authState = AuthError(e: e, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> loadProfile() async {
    _authState = AuthUnauthenticated();
    notifyListeners();
    try {
      final user = await _service.userChanges();
      if (user == null) return;

      final profile = UserProfile(
        userId: user.uid,
        name: user.displayName ?? "User",
        token: "",
      );
      _authState = AuthAuthenticated(user: profile);
    } catch (e) {
      _message = e.toString();
      _authState = AuthError(e: e, message: e.toString());
    }
    notifyListeners();
  }
}
