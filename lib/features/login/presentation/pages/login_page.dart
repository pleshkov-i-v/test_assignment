import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_case/core/di/service_locator.dart';
import 'package:test_case/domain/service/authentication_service.dart';
import 'package:test_case/features/home/presentation/pages/home_page.dart';
import 'package:test_case/features/login/presentation/bloc/login_bloc.dart';
import 'package:test_case/features/login/presentation/bloc/login_event.dart';
import 'package:test_case/features/login/presentation/bloc/login_state.dart';
import 'package:test_case/features/register/presentation/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) =>
          LoginBloc(authenticationService: getIt<AuthenticationService>()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAF5),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: BlocListener<LoginBloc, LoginState>(
                    listenWhen: (LoginState previous, LoginState current) =>
                        previous.status != current.status,
                    listener: (BuildContext context, LoginState state) {
                      if (state.status == LoginStatus.success) {
                        context.go(HomePage.routeName);
                      }

                      if (state.status == LoginStatus.failure &&
                          state.message != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message!)));
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (BuildContext context, LoginState state) {
                        final bool isLoading =
                            state.status == LoginStatus.loading;
                        final bool canSubmit = state.isFormValid && !isLoading;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Welcome back',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Log in to continue your lessons.',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _loginController,
                              textInputAction: TextInputAction.next,
                              onChanged: (String value) => context
                                  .read<LoginBloc>()
                                  .add(LoginChanged(value)),
                              decoration: InputDecoration(
                                labelText: 'Login',
                                filled: true,
                                fillColor: const Color(0xFFF4F7F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              onChanged: (String value) => context
                                  .read<LoginBloc>()
                                  .add(PasswordChanged(value)),
                              onSubmitted: (_) => context.read<LoginBloc>().add(
                                const LoginSubmitted(),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                filled: true,
                                fillColor: const Color(0xFFF4F7F2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: canSubmit
                                    ? () => context.read<LoginBloc>().add(
                                        const LoginSubmitted(),
                                      )
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF58CC02),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: const Color(
                                    0xFFB5DB97,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Log In',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.push(RegisterPage.routeName),
                              child: const Text('Create a new account'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
