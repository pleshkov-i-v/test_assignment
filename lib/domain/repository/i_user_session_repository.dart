import 'package:test_case/domain/model/user_id.dart';

abstract interface class IUserSessionRepository {
  Future<UserId?> getCurrentUserId();

  Future<void> saveCurrentUserId(UserId userId);

  Future<void> clearCurrentUserId();
}
