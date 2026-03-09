import 'package:sqflite/sqflite.dart';
import 'package:test_case/data/course/models/lesson_progress_dto.dart';
import 'package:test_case/domain/model/lesson_progress.dart';
import 'package:test_case/domain/model/user_id.dart';
import 'package:test_case/domain/repository/i_lesson_progress_repository.dart';

class LessonProgressRepository implements ILessonProgressRepository {
  LessonProgressRepository(this._db);

  static const String tableName = 'lesson_progress';

  final Database _db;

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        user_id TEXT NOT NULL,
        lesson_id TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        completed_at INTEGER,
        PRIMARY KEY (user_id, lesson_id)
      )
    ''');
  }

  @override
  Future<LessonProgress?> getLessonProgress(
    UserId userId,
    String lessonId,
  ) async {
    final rows = await _db.query(
      tableName,
      where: 'user_id = ? AND lesson_id = ?',
      whereArgs: [userId.id, lessonId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _mapToDomain(LessonProgressDto.fromMap(rows.first));
  }

  @override
  Future<Map<String, LessonProgress>> getAllLessonsProgress(
    UserId userId,
  ) async {
    final rows = await _db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId.id],
    );
    return {
      for (final row in rows)
        row['lesson_id'] as String: _mapToDomain(
          LessonProgressDto.fromMap(row),
        ),
    };
  }

  @override
  Future<void> saveLessonProgress(
    UserId userId,
    String lessonId,
    LessonProgress progress,
  ) async {
    final dto = LessonProgressDto(
      lessonId: progress.lessonId,
      isCompleted: progress.isCompleted,
      completedAt: progress.completedAt,
    );
    await _db.insert(
      tableName,
      dto.toMap(userId.id),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> clearUserProgress(UserId userId) async {
    await _db.delete(tableName, where: 'user_id = ?', whereArgs: [userId.id]);
  }

  LessonProgress _mapToDomain(LessonProgressDto dto) {
    return LessonProgress(
      lessonId: dto.lessonId,
      isCompleted: dto.isCompleted,
      completedAt: dto.completedAt,
    );
  }
}
