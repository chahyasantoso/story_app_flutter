import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/repositories/user_repository.dart';

class LogoutUser {
  final UserRepository _userRepo;
  LogoutUser(this._userRepo);

  Future<DomainResult<void>> call() {
    return _userRepo.logout();
  }
}
