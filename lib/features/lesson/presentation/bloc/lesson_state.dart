import 'package:test_case/domain/model/exercise.dart';

enum LessonStatus { initial, inProgress, completed }

class LessonState {
  const LessonState({
    required this.status,
    required this.lessonId,
    required this.lessonTitle,
    required this.exercises,
    required this.currentIndex,
  });

  const LessonState.initial()
    : status = LessonStatus.initial,
      lessonId = '',
      lessonTitle = '',
      exercises = const <Exercise>[],
      currentIndex = 0;

  final LessonStatus status;
  final String lessonId;
  final String lessonTitle;
  final List<Exercise> exercises;
  final int currentIndex;

  Exercise? get currentExercise {
    if (currentIndex < 0 || currentIndex >= exercises.length) {
      return null;
    }
    return exercises[currentIndex];
  }

  LessonState copyWith({
    LessonStatus? status,
    String? lessonId,
    String? lessonTitle,
    List<Exercise>? exercises,
    int? currentIndex,
  }) {
    return LessonState(
      status: status ?? this.status,
      lessonId: lessonId ?? this.lessonId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
