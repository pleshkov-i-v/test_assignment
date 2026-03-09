import 'package:test_case/data/user/dto/login_user_dto.dart';
import 'package:test_case/data/user/dto/register_user_dto.dart';

abstract interface class IAuthStorage {
  Future<void> register(RegisterUserDto dto);

  Future<String> authenticate(LoginUserDto dto);
}
