import 'package:test_case/domain/model/lesson.dart';
import 'package:test_case/domain/repository/i_course_repository.dart';

class LessonService {
  LessonService({required this.courseRepository});

  final ICourseRepository courseRepository;

  Future<Lesson> getLesson(String lessonId) async {
    final course = await courseRepository.getCourse();
    final Lesson lesson = course.lessons.firstWhere(
      (Lesson l) => l.id == lessonId,
    );
    return Lesson(
      id: lesson.id,
      order: lesson.order,
      title: lesson.title,
      exercises: lesson.exercises,
    );
  }
}
