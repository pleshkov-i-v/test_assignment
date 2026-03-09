import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_case/domain/service/lesson_service.dart';
import 'package:test_case/features/lesson/presentation/bloc/lesson_event.dart';
import 'package:test_case/features/lesson/presentation/bloc/lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  LessonBloc({required LessonService lessonService})
    : _lessonService = lessonService,
      super(const LessonState.initial()) {
    on<LessonStarted>(_onStarted);
    on<NextExerciseRequested>(_onNextExerciseRequested);
  }

  final LessonService _lessonService;

  Future<void> _onStarted(
    LessonStarted event,
    Emitter<LessonState> emit,
  ) async {
    final lessonData = await _lessonService.getLesson(event.lessonId);

    final exercises = lessonData.exercises.toList(growable: false);

    emit(
      state.copyWith(
        status: LessonStatus.inProgress,
        lessonId: lessonData.id,
        lessonTitle: lessonData.title,
        exercises: exercises,
        currentIndex: 0,
      ),
    );
  }

  void _onNextExerciseRequested(
    NextExerciseRequested event,
    Emitter<LessonState> emit,
  ) {
    if (state.status != LessonStatus.inProgress) {
      return;
    }

    final int nextIndex = state.currentIndex + 1;
    final bool isCompleted = nextIndex >= state.exercises.length;

    emit(
      state.copyWith(
        status: isCompleted ? LessonStatus.completed : LessonStatus.inProgress,
        currentIndex: nextIndex,
      ),
    );
  }
}
