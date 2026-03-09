import 'dart:convert';

import 'package:test_case/core/bundle/i_bundle_repository.dart';
import 'package:test_case/data/course/models/course_dto.dart';
import 'package:test_case/data/course/models/exercise_dto.dart';
import 'package:test_case/data/course/models/lesson_dto.dart';
import 'package:test_case/domain/model/course.dart';
import 'package:test_case/domain/model/lesson.dart';
import 'package:test_case/domain/model/exercise.dart';
import 'package:test_case/domain/repository/i_course_repository.dart';

class CourseRepository implements ICourseRepository {
  final IBundleRepository bundleRepository;

  CourseRepository(this.bundleRepository);

  @override
  Future<Course> getCourse() async {
    try {
      final String jsonString = await bundleRepository.getAsString(
        'assets/data/sample-json.json',
      );

      final Map<String, dynamic> jsonMap = jsonString.isNotEmpty
          ? (await Future.value(jsonDecode(jsonString))) as Map<String, dynamic>
          : {};

      final CourseDto dto = CourseDto.fromJson(jsonMap);
      return _mapCourse(dto);
    } catch (e) {
      throw Exception('Failed to load course data: $e');
    }
  }

  Course _mapCourse(CourseDto dto) {
    return Course(
      courseTitle: dto.courseTitle,
      lessons: dto.lessons.map(_mapLesson).toList(),
    );
  }

  Lesson _mapLesson(LessonDto dto) {
    return Lesson(
      id: dto.id,
      order: dto.order,
      title: dto.title,
      exercises: dto.exercises.map(_mapExercise).toList(),
    );
  }

  Exercise _mapExercise(ExerciseDto dto) {
    return switch (dto.type) {
      ExerciseType.readOutLoud => ReadOutLoudExercise(
        id: dto.id,
        textToRead: dto.textToRead!,
      ),
      ExerciseType.translate => MultipleChoiceExercise(
        id: dto.id,
        phrase: dto.phrase!,
        options: dto.options!,
        correctOptionIndex: dto.correctOptionIndex!,
      ),
    };
  }
}
