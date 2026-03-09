import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:test_case/core/bundle/bundle_repository.dart';
import 'package:test_case/core/bundle/i_bundle_repository.dart';
import 'package:test_case/data/course/repository/course_repository.dart';
import 'package:test_case/data/course/repository/lesson_progress_repository.dart';
import 'package:test_case/data/user/repository/auth_storage.dart';
import 'package:test_case/data/user/repository/i_auth_storage.dart';
import 'package:test_case/domain/repository/i_course_repository.dart';
import 'package:test_case/domain/repository/i_lesson_progress_repository.dart';
import 'package:test_case/domain/repository/i_user_session_repository.dart';
import 'package:test_case/domain/service/course_service.dart';
import 'package:test_case/domain/service/lesson_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  if (getIt.isRegistered<Database>()) {
    return;
  }

  final Database db = await openDatabase(
    p.join(await getDatabasesPath(), 'app.db'),
    onCreate: (db, version) => LessonProgressRepository.createTable(db),
    version: 1,
  );

  getIt.registerSingleton<Database>(db);

  final AuthStorage authStorage = AuthStorage();
  getIt.registerLazySingleton<IAuthStorage>(() => authStorage);
  getIt.registerLazySingleton<IUserSessionRepository>(() => authStorage);

  getIt.registerLazySingleton<IBundleRepository>(() => BundleRepository());
  getIt.registerLazySingleton<ICourseRepository>(
    () => CourseRepository(getIt<IBundleRepository>()),
  );
  getIt.registerLazySingleton<ILessonProgressRepository>(
    () => LessonProgressRepository(getIt<Database>()),
  );
  getIt.registerLazySingleton<CourseService>(
    () => CourseService(
      userSessionRepository: getIt<IUserSessionRepository>(),
      courseRepository: getIt<ICourseRepository>(),
      progressRepository: getIt<ILessonProgressRepository>(),
    ),
  );
  getIt.registerLazySingleton<LessonService>(
    () => LessonService(courseRepository: getIt<ICourseRepository>()),
  );
}
