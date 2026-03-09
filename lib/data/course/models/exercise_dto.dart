import 'package:json_annotation/json_annotation.dart';

part 'exercise_dto.g.dart';

@JsonEnum(alwaysCreate: true)
enum ExerciseType {
  @JsonValue('read_out_loud')
  readOutLoud,
  @JsonValue('translate')
  translate,
}

@JsonSerializable()
class ExerciseDto {
  const ExerciseDto({
    required this.id,
    required this.type,
    this.textToRead,
    this.phrase,
    this.options,
    this.correctOptionIndex,
  });

  final String id;
  final ExerciseType type;

  @JsonKey(name: 'text_to_read')
  final String? textToRead;
  final String? phrase;
  final List<String>? options;

  @JsonKey(name: 'correct_option_index')
  final int? correctOptionIndex;

  factory ExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$ExerciseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseDtoToJson(this);
}
