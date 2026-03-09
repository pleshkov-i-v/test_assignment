import 'package:test_case/domain/model/home/course_lesson_item.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState {
  const HomeState({
    required this.status,
    required this.courseTitle,
    required this.lessons,
    required this.message,
  });

  const HomeState.initial()
    : status = HomeStatus.initial,
      courseTitle = '',
      lessons = const <CourseLessonItem>[],
      message = null;

  final HomeStatus status;
  final String courseTitle;
  final List<CourseLessonItem> lessons;
  final String? message;

  HomeState copyWith({
    HomeStatus? status,
    String? courseTitle,
    List<CourseLessonItem>? lessons,
    String? message,
    bool clearMessage = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      courseTitle: courseTitle ?? this.courseTitle,
      lessons: lessons ?? this.lessons,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}
