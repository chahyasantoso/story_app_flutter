import 'package:story_app/domain/entities/user_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

abstract class UserRepository {
  Future<DomainResult<void>> register(
    String name,
    String email,
    String password,
  );
  Future<DomainResult<UserEntity>> login(String email, String password);
  Future<DomainResult<void>> logout();
  Future<DomainResult<UserEntity?>> load();
}
