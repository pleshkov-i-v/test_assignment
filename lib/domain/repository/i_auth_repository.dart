import 'package:test_case/domain/model/user_id.dart';

abstract interface class IAuthRepository {
  Future<void> register(String login, String password);

  Future<UserId> authenticate(String login, String password);
}
