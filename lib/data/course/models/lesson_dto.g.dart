// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LessonDto _$LessonDtoFromJson(Map<String, dynamic> json) => LessonDto(
  id: json['id'] as String,
  order: (json['order'] as num).toInt(),
  title: json['title'] as String,
  exercises: (json['exercises'] as List<dynamic>)
      .map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LessonDtoToJson(LessonDto instance) => <String, dynamic>{
  'id': instance.id,
  'order': instance.order,
  'title': instance.title,
  'exercises': instance.exercises,
};
