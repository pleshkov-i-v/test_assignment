import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/domain/exceptions/user_is_not_logged_in_exception.dart';
import 'package:test_case/domain/model/home/course_lesson_item.dart';
import 'package:test_case/domain/service/course_service.dart';
import 'package:test_case/features/home/presentation/bloc/home_event.dart';
import 'package:test_case/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required CourseService courseService})
    : _courseService = courseService,
      super(const HomeState.initial()) {
    on<HomeRequested>(_onRequested);
    on<LessonCompleted>(_onLessonCompleted);
  }

  final CourseService _courseService;

  Future<void> _onRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, clearMessage: true));

    try {
      final courseData = await _courseService.getCourseData();

      emit(
        state.copyWith(
          status: HomeStatus.success,
          courseTitle: courseData.courseTitle,
          lessons: courseData.lessons,
          clearMessage: true,
        ),
      );
    } on UserIsNotLoggedInException catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          message: 'User not logged in.',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          message: 'Failed to load lessons. Please try again.',
        ),
      );
    }
  }

  Future<void> _onLessonCompleted(
    LessonCompleted event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final List<CourseLessonItem> updated = await _courseService
          .markLessonCompleted(event.lessonId, state.lessons);

      emit(state.copyWith(lessons: updated));
    } on UserIsNotLoggedInException catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          message: 'User not logged in.',
        ),
      );
    } catch (_) {
      // Progress save failure is non-critical
    }
  }
}
