sealed class RegisterEvent {
  const RegisterEvent();
}

final class RegisterLoginChanged extends RegisterEvent {
  const RegisterLoginChanged(this.login);

  final String login;
}

final class RegisterPasswordChanged extends RegisterEvent {
  const RegisterPasswordChanged(this.password);

  final String password;
}

final class RegisterConfirmPasswordChanged extends RegisterEvent {
  const RegisterConfirmPasswordChanged(this.confirmPassword);

  final String confirmPassword;
}

final class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}
