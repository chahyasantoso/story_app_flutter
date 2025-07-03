import 'package:story_app/domain/entities/user_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/repositories/user_repository.dart';

class LoadUser {
  final UserRepository _userRepo;
  LoadUser(this._userRepo);

  Future<DomainResult<UserEntity?>> call() {
    return _userRepo.load();
  }
}
