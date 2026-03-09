import 'package:test_case/data/user/dto/login_user_dto.dart';
import 'package:test_case/data/user/dto/register_user_dto.dart';
import 'package:test_case/data/user/repository/i_auth_storage.dart';
import 'package:test_case/domain/model/user_id.dart';
import 'package:test_case/domain/repository/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  AuthRepository({required this.authStorage});

  final IAuthStorage authStorage;

  @override
  Future<void> register(String login, String password) async {
    await authStorage.register(
      RegisterUserDto(login: login, password: password),
    );
  }

  @override
  Future<UserId> authenticate(String login, String password) async {
    await authStorage.authenticate(
      LoginUserDto(login: login, password: password),
    );
    return UserId(id: login);
  }
}
