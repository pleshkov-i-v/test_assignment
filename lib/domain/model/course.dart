import 'package:test_case/domain/model/lesson.dart';

class Course {
  const Course({required this.courseTitle, required this.lessons});

  final String courseTitle;
  final List<Lesson> lessons;
}
