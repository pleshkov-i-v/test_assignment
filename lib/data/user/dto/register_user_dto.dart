class RegisterUserDto {
  const RegisterUserDto({
    required this.login,
    required this.password,
  });

  final String login;
  final String password;
}
