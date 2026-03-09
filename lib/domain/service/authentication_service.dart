import 'package:test_case/domain/model/user_id.dart';
import 'package:test_case/domain/repository/i_auth_repository.dart';
import 'package:test_case/domain/repository/i_user_session_repository.dart';

class AuthenticationService {
  AuthenticationService({
    required IAuthRepository authRepository,
    required IUserSessionRepository userSessionRepository,
  }) : _authRepository = authRepository,
       _userSessionRepository = userSessionRepository;

  final IAuthRepository _authRepository;
  final IUserSessionRepository _userSessionRepository;

  Future<void> register({
    required String login,
    required String password,
  }) async {
    await _authRepository.register(login, password);
  }

  Future<void> authenticate({
    required String login,
    required String password,
  }) async {
    final userId = await _authRepository.authenticate(login, password);
    await _userSessionRepository.saveCurrentUserId(userId);
  }

  Future<UserId?> getCurrentUserId() async {
    return await _userSessionRepository.getCurrentUserId();
  }

  Future<void> clearCurrentUserId() async {
    await _userSessionRepository.clearCurrentUserId();
  }
}
