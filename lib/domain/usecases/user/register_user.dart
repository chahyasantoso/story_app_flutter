import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/repositories/user_repository.dart';

class RegisterUser {
  final UserRepository _userRepo;
  RegisterUser(this._userRepo);

  Future<DomainResult<void>> call(String name, String email, String password) {
    return _userRepo.register(name, email, password);
  }
}
