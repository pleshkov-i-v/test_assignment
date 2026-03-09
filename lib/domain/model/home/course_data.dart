import 'package:test_case/domain/model/home/course_lesson_item.dart';

class CourseData {
  const CourseData({required this.courseTitle, required this.lessons});

  final String courseTitle;
  final List<CourseLessonItem> lessons;
}
