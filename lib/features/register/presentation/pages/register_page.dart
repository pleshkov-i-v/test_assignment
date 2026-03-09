import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_case/core/di/service_locator.dart';
import 'package:test_case/domain/service/authentication_service.dart';
import 'package:test_case/features/login/presentation/pages/login_page.dart';
import 'package:test_case/features/register/presentation/bloc/register_bloc.dart';
import 'package:test_case/features/register/presentation/bloc/register_event.dart';
import 'package:test_case/features/register/presentation/bloc/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _loginController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (_) =>
          RegisterBloc(authenticationService: getIt<AuthenticationService>()),
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
                  child: BlocListener<RegisterBloc, RegisterState>(
                    listenWhen:
                        (RegisterState previous, RegisterState current) =>
                            previous.status != current.status,
                    listener: (BuildContext context, RegisterState state) {
                      if (state.status == RegisterStatus.success) {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Success'),
                              content: const Text(
                                'Your account was created successfully.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    dialogContext.pop();
                                    context.go(LoginPage.routeName);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      if (state.status == RegisterStatus.failure &&
                          state.message != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message!)));
                      }
                    },
                    child: BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (BuildContext context, RegisterState state) {
                        final bool isLoading =
                            state.status == RegisterStatus.loading;
                        final bool canSubmit = state.isFormValid && !isLoading;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Create your account',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start your learning streak today.',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.black54),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _loginController,
                              textInputAction: TextInputAction.next,
                              onChanged: (String value) => context
                                  .read<RegisterBloc>()
                                  .add(RegisterLoginChanged(value)),
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
                              textInputAction: TextInputAction.next,
                              onChanged: (String value) => context
                                  .read<RegisterBloc>()
                                  .add(RegisterPasswordChanged(value)),
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
                            const SizedBox(height: 12),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              onChanged: (String value) => context
                                  .read<RegisterBloc>()
                                  .add(RegisterConfirmPasswordChanged(value)),
                              onSubmitted: (_) => context
                                  .read<RegisterBloc>()
                                  .add(const RegisterSubmitted()),
                              decoration: InputDecoration(
                                labelText: 'Confirm password',
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
                                    ? () => context.read<RegisterBloc>().add(
                                        const RegisterSubmitted(),
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
                                        'Register',
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
                                  : () => context.go(LoginPage.routeName),
                              child: const Text('Back to login'),
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
