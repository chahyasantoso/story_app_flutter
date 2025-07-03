import 'package:story_app/domain/entities/user_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/repositories/user_repository.dart';

class LoginUser {
  final UserRepository _userRepo;
  LoginUser(this._userRepo);

  Future<DomainResult<UserEntity>> call(String email, String password) {
    return _userRepo.login(email, password);
  }
}
