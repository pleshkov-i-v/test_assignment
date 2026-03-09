// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseDto _$CourseDtoFromJson(Map<String, dynamic> json) => CourseDto(
  courseTitle: json['course_title'] as String,
  lessons: (json['lessons'] as List<dynamic>)
      .map((e) => LessonDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseDtoToJson(CourseDto instance) => <String, dynamic>{
  'course_title': instance.courseTitle,
  'lessons': instance.lessons,
};
