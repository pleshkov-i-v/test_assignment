class DomainException implements Exception {
  DomainException({required this.message});

  final String message;
}

class UserIsNotLoggedInException extends DomainException {
  UserIsNotLoggedInException() : super(message: 'User is not logged in');
}

class AuthenticationFailedException extends DomainException {
  AuthenticationFailedException() : super(message: 'Authentication failed');
}

class RegisterFailedException extends DomainException {
  RegisterFailedException() : super(message: 'Register failed');
}
