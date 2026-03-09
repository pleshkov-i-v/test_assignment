import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_case/core/di/service_locator.dart';
import 'package:test_case/domain/model/user_id.dart';
import 'package:test_case/domain/repository/i_user_session_repository.dart';
import 'package:test_case/features/home/presentation/pages/home_page.dart';
import 'package:test_case/features/lesson/presentation/pages/lesson_page.dart';
import 'package:test_case/features/login/presentation/pages/login_page.dart';
import 'package:test_case/features/register/presentation/pages/register_page.dart';
import 'package:test_case/features/splash/presentation/pages/splash_page.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  late final GoRouter router = _buildRouter();

  static GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: SplashPage.routeName,
      routes: <RouteBase>[
        GoRoute(
          path: SplashPage.routeName,
          builder: (_, _) => const SplashPage(),
        ),
        GoRoute(
          path: LoginPage.routeName,
          builder: (_, _) => const LoginPage(),
        ),
        GoRoute(
          path: RegisterPage.routeName,
          builder: (_, _) => const RegisterPage(),
        ),
        GoRoute(path: HomePage.routeName, builder: (_, _) => const HomePage()),
        GoRoute(
          path: LessonPage.routeName,
          builder: (_, GoRouterState state) => LessonPage(
            pageArgs: state.extra is LessonPageArgs
                ? state.extra! as LessonPageArgs
                : null,
          ),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) async {
        final bool isSplashRoute =
            state.matchedLocation == SplashPage.routeName;
        if (isSplashRoute) {
          return SplashPage.routeName;
        }

        final UserId? userId = await getIt<IUserSessionRepository>()
            .getCurrentUserId();
        final bool isAuthed = userId != null;
        final bool isAuthRoute =
            state.matchedLocation == LoginPage.routeName ||
            state.matchedLocation == RegisterPage.routeName;

        if (!isAuthed && !isAuthRoute) {
          return LoginPage.routeName;
        }
        if (isAuthed && isAuthRoute) {
          return HomePage.routeName;
        }
        return null;
      },
    );
  }

  void dispose() {
    router.dispose();
  }
}
