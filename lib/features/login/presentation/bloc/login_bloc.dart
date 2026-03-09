import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/domain/exceptions/user_is_not_logged_in_exception.dart';
import 'package:test_case/domain/service/authentication_service.dart';
import 'package:test_case/features/login/presentation/bloc/login_event.dart';
import 'package:test_case/features/login/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthenticationService authenticationService})
    : _authenticationService = authenticationService,

      super(const LoginState.initial()) {
    on<LoginChanged>(_onLoginChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthenticationService _authenticationService;

  void _onLoginChanged(LoginChanged event, Emitter<LoginState> emit) {
    final String value = event.login;
    emit(
      state.copyWith(
        status: LoginStatus.initial,
        login: value,
        isLoginValid: value.trim().isNotEmpty,
        clearMessage: true,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final String value = event.password;
    emit(
      state.copyWith(
        status: LoginStatus.initial,
        password: value,
        isPasswordValid: value.isNotEmpty,
        clearMessage: true,
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          message: 'Please enter login and password.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, clearMessage: true));

    try {
      await _authenticationService.authenticate(
        login: state.login,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success, clearMessage: true));
    } on AuthenticationFailedException catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          message: 'Invalid login or password.',
        ),
      );
    } on ArgumentError catch (error) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          message: error.message?.toString() ?? 'Invalid input.',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          message: 'Authentication failed. Please try again.',
        ),
      );
    }
  }
}
