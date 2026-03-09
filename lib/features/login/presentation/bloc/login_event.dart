sealed class LoginEvent {
  const LoginEvent();
}

final class LoginChanged extends LoginEvent {
  const LoginChanged(this.login);

  final String login;
}

final class PasswordChanged extends LoginEvent {
  const PasswordChanged(this.password);

  final String password;
}

final class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
