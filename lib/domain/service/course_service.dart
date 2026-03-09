import 'package:test_case/domain/exceptions/user_is_not_logged_in_exception.dart';
import 'package:test_case/domain/model/course.dart';
import 'package:test_case/domain/model/home/course_data.dart';
import 'package:test_case/domain/model/home/course_lesson_item.dart';
import 'package:test_case/domain/model/lesson.dart';
import 'package:test_case/domain/model/lesson_progress.dart';
import 'package:test_case/domain/model/user_id.dart';
import 'package:test_case/domain/repository/i_course_repository.dart';
import 'package:test_case/domain/repository/i_lesson_progress_repository.dart';
import 'package:test_case/domain/repository/i_user_session_repository.dart';

class CourseService {
  CourseService({
    required IUserSessionRepository userSessionRepository,
    required ICourseRepository courseRepository,
    required ILessonProgressRepository progressRepository,
  }) : _userSessionRepository = userSessionRepository,
       _courseRepository = courseRepository,
       _progressRepository = progressRepository;

  final IUserSessionRepository _userSessionRepository;
  final ICourseRepository _courseRepository;
  final ILessonProgressRepository _progressRepository;

  Future<CourseData> getCourseData() async {
    final UserId? userId = await _userSessionRepository.getCurrentUserId();
    if (userId == null) {
      throw UserIsNotLoggedInException();
    }
    final Course course = await _courseRepository.getCourse();
    final Map<String, LessonProgress> progress = await _progressRepository
        .getAllLessonsProgress(userId);

    final List<Lesson> sortedLessons = List<Lesson>.from(course.lessons)
      ..sort((Lesson a, Lesson b) => a.order.compareTo(b.order));

    final List<CourseLessonItem> lessons = _buildLessonItems(
      sortedLessons,
      progress,
    );

    return CourseData(courseTitle: course.courseTitle, lessons: lessons);
  }

  Future<List<CourseLessonItem>> markLessonCompleted(
    String lessonId,
    List<CourseLessonItem> currentLessons,
  ) async {
    final UserId? userId = await _userSessionRepository.getCurrentUserId();
    if (userId == null) {
      throw UserIsNotLoggedInException();
    }
    await _progressRepository.saveLessonProgress(
      userId,
      lessonId,
      LessonProgress(
        lessonId: lessonId,
        isCompleted: true,
        completedAt: DateTime.now(),
      ),
    );

    final List<CourseLessonItem> updated = currentLessons.map((
      CourseLessonItem item,
    ) {
      if (item.id == lessonId) {
        return CourseLessonItem(
          id: item.id,
          title: item.title,
          order: item.order,
          isLocked: false,
          isCompleted: true,
        );
      }
      return item;
    }).toList();

    return _recomputeLocked(updated);
  }

  List<CourseLessonItem> _buildLessonItems(
    List<Lesson> sortedLessons,
    Map<String, LessonProgress> progress,
  ) {
    final List<CourseLessonItem> items = [];
    for (int i = 0; i < sortedLessons.length; i++) {
      final Lesson lesson = sortedLessons[i];
      final bool isCompleted = progress[lesson.id]?.isCompleted ?? false;
      final bool isLocked = i > 0 && !items[i - 1].isCompleted;
      items.add(
        CourseLessonItem(
          id: lesson.id,
          title: lesson.title,
          order: lesson.order,
          isLocked: isLocked,
          isCompleted: isCompleted,
        ),
      );
    }
    return items;
  }

  List<CourseLessonItem> _recomputeLocked(List<CourseLessonItem> lessons) {
    final List<CourseLessonItem> result = [];
    for (int i = 0; i < lessons.length; i++) {
      final CourseLessonItem item = lessons[i];
      final bool isLocked = i > 0 && !result[i - 1].isCompleted;
      result.add(
        CourseLessonItem(
          id: item.id,
          title: item.title,
          order: item.order,
          isLocked: isLocked,
          isCompleted: item.isCompleted,
        ),
      );
    }
    return result;
  }
}
