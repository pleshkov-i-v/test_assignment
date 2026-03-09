sealed class HomeEvent {
  const HomeEvent();
}

final class HomeRequested extends HomeEvent {
  const HomeRequested();
}

final class LessonCompleted extends HomeEvent {
  const LessonCompleted({required this.lessonId});

  final String lessonId;
}
