import 'package:json_annotation/json_annotation.dart';

import 'lesson_dto.dart';

part 'course_dto.g.dart';

@JsonSerializable()
class CourseDto {
  const CourseDto({
    required this.courseTitle,
    required this.lessons,
  });

  @JsonKey(name: 'course_title')
  final String courseTitle;
  final List<LessonDto> lessons;

  factory CourseDto.fromJson(Map<String, dynamic> json) =>
      _$CourseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CourseDtoToJson(this);
}
