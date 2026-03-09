import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/domain/exceptions/user_is_not_logged_in_exception.dart';
import 'package:test_case/domain/service/authentication_service.dart';
import 'package:test_case/features/register/presentation/bloc/register_event.dart';
import 'package:test_case/features/register/presentation/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthenticationService authenticationService})
    : _authenticationService = authenticationService,
      super(const RegisterState.initial()) {
    on<RegisterLoginChanged>(_onLoginChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  final AuthenticationService _authenticationService;

  void _onLoginChanged(
    RegisterLoginChanged event,
    Emitter<RegisterState> emit,
  ) {
    final String login = event.login;
    emit(
      state.copyWith(
        status: RegisterStatus.initial,
        login: login,
        isLoginValid: login.trim().isNotEmpty,
        isPasswordsMatch: _isPasswordsMatch(
          password: state.password,
          confirmPassword: state.confirmPassword,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final String password = event.password;
    emit(
      state.copyWith(
        status: RegisterStatus.initial,
        password: password,
        isPasswordValid: password.isNotEmpty,
        isPasswordsMatch: _isPasswordsMatch(
          password: password,
          confirmPassword: state.confirmPassword,
        ),
        clearMessage: true,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final String confirmPassword = event.confirmPassword;
    emit(
      state.copyWith(
        status: RegisterStatus.initial,
        confirmPassword: confirmPassword,
        isConfirmPasswordValid: confirmPassword.isNotEmpty,
        isPasswordsMatch: _isPasswordsMatch(
          password: state.password,
          confirmPassword: confirmPassword,
        ),
        clearMessage: true,
      ),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          message: 'Please fill all fields and make sure passwords match.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading, clearMessage: true));

    try {
      await _authenticationService.register(
        login: state.login,
        password: state.password,
      );
      emit(state.copyWith(status: RegisterStatus.success, clearMessage: true));
    } on RegisterFailedException catch (_) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          message: 'Registration failed.',
        ),
      );
    } on ArgumentError catch (error) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          message: error.message?.toString() ?? 'Invalid input.',
        ),
      );
    } on StateError catch (error) {
      emit(
        state.copyWith(status: RegisterStatus.failure, message: error.message),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          message: 'Registration failed. Please try again.',
        ),
      );
    }
  }

  bool _isPasswordsMatch({
    required String password,
    required String confirmPassword,
  }) {
    return password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }
}
