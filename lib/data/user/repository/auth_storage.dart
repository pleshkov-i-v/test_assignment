import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_case/data/user/dto/login_user_dto.dart';
import 'package:test_case/data/user/dto/register_user_dto.dart';
import 'package:test_case/data/user/dto/stored_user_credentials_dto.dart';
import 'package:test_case/data/user/repository/i_auth_storage.dart';
import 'package:test_case/domain/exceptions/user_is_not_logged_in_exception.dart';
import 'package:test_case/domain/model/user_id.dart';
import 'package:test_case/domain/repository/i_user_session_repository.dart';

class AuthStorage implements IAuthStorage, IUserSessionRepository {
  AuthStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _userStoragePrefix = 'user_credentials_';
  static const String _currentUserIdKey = 'current_user_id';

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> register(RegisterUserDto dto) async {
    final String normalizedLogin = _normalizeLogin(dto.login);
    _validatePassword(dto.password);

    final String storageKey = _userStorageKey(normalizedLogin);
    final String? existing = await _secureStorage.read(key: storageKey);

    if (existing != null) {
      throw StateError('User with this login already exists.');
    }

    final String salt = _generateSalt();
    final String passwordHash = _hashPassword(dto.password, salt);

    final StoredUserCredentialsDto storedDto = StoredUserCredentialsDto(
      login: normalizedLogin,
      passwordHash: passwordHash,
      passwordSalt: salt,
    );

    await _secureStorage.write(
      key: storageKey,
      value: jsonEncode(storedDto.toJson()),
    );
  }

  @override
  Future<String> authenticate(LoginUserDto dto) async {
    final String normalizedLogin = _normalizeLogin(dto.login);
    final String storageKey = _userStorageKey(normalizedLogin);

    final String? rawCredentials = await _secureStorage.read(key: storageKey);
    if (rawCredentials == null) {
      throw AuthenticationFailedException();
    }

    final StoredUserCredentialsDto storedDto =
        StoredUserCredentialsDto.fromJson(
          (jsonDecode(rawCredentials) as Map<String, dynamic>),
        );

    final String providedHash = _hashPassword(
      dto.password,
      storedDto.passwordSalt,
    );

    if (!_constantTimeEquals(providedHash, storedDto.passwordHash)) {
      throw AuthenticationFailedException();
    } else {
      return normalizedLogin;
    }
  }

  @override
  Future<void> saveCurrentUserId(UserId userId) async {
    await _secureStorage.write(key: _currentUserIdKey, value: userId.id);
  }

  @override
  Future<UserId?> getCurrentUserId() async {
    final String? userId = await _secureStorage.read(key: _currentUserIdKey);

    return userId != null ? UserId(id: userId) : null;
  }

  @override
  Future<void> clearCurrentUserId() async {
    await _secureStorage.delete(key: _currentUserIdKey);
  }

  String _normalizeLogin(String login) {
    final String normalized = login.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('Login can not be empty.');
    }

    return normalized;
  }

  void _validatePassword(String password) {
    if (password.isEmpty) {
      throw ArgumentError('Password can not be empty.');
    }
  }

  String _userStorageKey(String login) => '$_userStoragePrefix$login';

  String _generateSalt() {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64Encode(bytes);
  }

  String _hashPassword(String password, String salt) {
    final List<int> payload = utf8.encode('$salt$password');
    return sha256.convert(payload).toString();
  }

  bool _constantTimeEquals(String left, String right) {
    if (left.length != right.length) {
      return false;
    }

    int difference = 0;
    for (int i = 0; i < left.length; i++) {
      difference |= left.codeUnitAt(i) ^ right.codeUnitAt(i);
    }

    return difference == 0;
  }
}
