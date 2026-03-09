enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  const RegisterState({
    required this.status,
    required this.login,
    required this.password,
    required this.confirmPassword,
    required this.isLoginValid,
    required this.isPasswordValid,
    required this.isConfirmPasswordValid,
    required this.isPasswordsMatch,
    required this.message,
  });

  const RegisterState.initial()
    : status = RegisterStatus.initial,
      login = '',
      password = '',
      confirmPassword = '',
      isLoginValid = false,
      isPasswordValid = false,
      isConfirmPasswordValid = false,
      isPasswordsMatch = false,
      message = null;

  final RegisterStatus status;
  final String login;
  final String password;
  final String confirmPassword;
  final bool isLoginValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final bool isPasswordsMatch;
  final String? message;

  bool get isFormValid =>
      isLoginValid &&
      isPasswordValid &&
      isConfirmPasswordValid &&
      isPasswordsMatch;

  RegisterState copyWith({
    RegisterStatus? status,
    String? login,
    String? password,
    String? confirmPassword,
    bool? isLoginValid,
    bool? isPasswordValid,
    bool? isConfirmPasswordValid,
    bool? isPasswordsMatch,
    String? message,
    bool clearMessage = false,
  }) {
    return RegisterState(
      status: status ?? this.status,
      login: login ?? this.login,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoginValid: isLoginValid ?? this.isLoginValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isConfirmPasswordValid: isConfirmPasswordValid ?? this.isConfirmPasswordValid,
      isPasswordsMatch: isPasswordsMatch ?? this.isPasswordsMatch,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
