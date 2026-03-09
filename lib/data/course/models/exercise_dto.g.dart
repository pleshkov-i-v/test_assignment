// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseDto _$ExerciseDtoFromJson(Map<String, dynamic> json) => ExerciseDto(
  id: json['id'] as String,
  type: $enumDecode(_$ExerciseTypeEnumMap, json['type']),
  textToRead: json['text_to_read'] as String?,
  phrase: json['phrase'] as String?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  correctOptionIndex: (json['correct_option_index'] as num?)?.toInt(),
);

Map<String, dynamic> _$ExerciseDtoToJson(ExerciseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ExerciseTypeEnumMap[instance.type]!,
      'text_to_read': instance.textToRead,
      'phrase': instance.phrase,
      'options': instance.options,
      'correct_option_index': instance.correctOptionIndex,
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.readOutLoud: 'read_out_loud',
  ExerciseType.translate: 'translate',
};
