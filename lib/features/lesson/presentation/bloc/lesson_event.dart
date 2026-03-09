sealed class LessonEvent {
  const LessonEvent();
}

final class LessonStarted extends LessonEvent {
  const LessonStarted({required this.lessonId});

  final String lessonId;
}

final class NextExerciseRequested extends LessonEvent {
  const NextExerciseRequested();
}
