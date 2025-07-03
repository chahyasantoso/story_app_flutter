import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/model/login_result.dart';
import 'package:story_app/data/services/shared_preferences_service.dart';
import 'package:story_app/data/services/story_auth_service.dart';
import 'package:story_app/domain/entities/user_entity.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/domain/repositories/user_repository.dart';

class UserRepositoryCache extends UserRepository {
  final StoryAuthService _authService;
  final SharedPreferencesService _prefService;

  UserRepositoryCache(this._authService, this._prefService);

  @override
  Future<DomainResult<UserEntity>> login(String email, String password) async {
    try {
      final response = await _authService.loginUser(email, password);
      final loginResult = LoginResult.fromJson(response.loginResult.toJson());
      await _prefService.saveUserValue(loginResult);

      final userEntity = loginResult.toEntity();
      return DomainResultSuccess(data: userEntity, message: response.message);
    } on HttpException catch (e) {
      return DomainResultError(message: e.message);
    } catch (e) {
      debugPrint("Error $e");
      return DomainResultError(message: "Login fail");
    }
  }

  @override
  Future<DomainResult<void>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _authService.registerUser(name, email, password);
      return DomainResultSuccess(data: null, message: response.message);
    } on HttpException catch (e) {
      return DomainResultError(message: e.message);
    } catch (e) {
      debugPrint("Error $e");
      return DomainResultError(message: "Register fail");
    }
  }

  @override
  Future<DomainResult<void>> logout() async {
    try {
      await _prefService.removeUserValue();
      return DomainResultSuccess(data: null);
    } catch (e) {
      debugPrint("Error $e");
      return DomainResultError(message: "Logout fail");
    }
  }

  @override
  Future<DomainResult<UserEntity?>> load() async {
    try {
      final loginResult = await _prefService.getUserValue();
      final userEntity = loginResult?.toEntity();

      return DomainResultSuccess(data: userEntity);
    } catch (e) {
      debugPrint("Error $e");
      return DomainResultError(message: "Load fail");
    }
  }
}
