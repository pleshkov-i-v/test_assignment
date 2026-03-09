import 'package:test_case/domain/model/lesson_progress.dart';
import 'package:test_case/domain/model/user_id.dart';

abstract interface class ILessonProgressRepository {
  Future<LessonProgress?> getLessonProgress(UserId userId, String lessonId);

  Future<Map<String, LessonProgress>> getAllLessonsProgress(UserId userId);

  Future<void> saveLessonProgress(
    UserId userId,
    String lessonId,
    LessonProgress progress,
  );

  Future<void> clearUserProgress(UserId userId);
}
