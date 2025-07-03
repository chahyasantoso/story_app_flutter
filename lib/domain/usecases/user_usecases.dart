import 'package:story_app/domain/usecases/user/load_user.dart';
import 'package:story_app/domain/usecases/user/login_user.dart';
import 'package:story_app/domain/usecases/user/logout_user.dart';
import 'package:story_app/domain/usecases/user/register_user.dart';

class UserUsecases {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final LoadUser loadUser;

  UserUsecases({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.loadUser,
  });
}
