import 'package:json_annotation/json_annotation.dart';

import 'exercise_dto.dart';

part 'lesson_dto.g.dart';

@JsonSerializable()
class LessonDto {
  const LessonDto({
    required this.id,
    required this.order,
    required this.title,
    required this.exercises,
  });

  final String id;
  final int order;
  final String title;
  final List<ExerciseDto> exercises;

  factory LessonDto.fromJson(Map<String, dynamic> json) =>
      _$LessonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LessonDtoToJson(this);
}
