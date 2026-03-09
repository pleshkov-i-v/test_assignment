enum LoginStatus { initial, loading, success, failure }

class LoginState {
  const LoginState({
    required this.status,
    required this.login,
    required this.password,
    required this.isLoginValid,
    required this.isPasswordValid,
    required this.message,
  });

  const LoginState.initial()
    : status = LoginStatus.initial,
      login = '',
      password = '',
      isLoginValid = false,
      isPasswordValid = false,
      message = null;

  final LoginStatus status;
  final String login;
  final String password;
  final bool isLoginValid;
  final bool isPasswordValid;
  final String? message;

  bool get isFormValid => isLoginValid && isPasswordValid;

  LoginState copyWith({
    LoginStatus? status,
    String? login,
    String? password,
    bool? isLoginValid,
    bool? isPasswordValid,
    String? message,
    bool clearMessage = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      login: login ?? this.login,
      password: password ?? this.password,
      isLoginValid: isLoginValid ?? this.isLoginValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
