class LessonProgressDto {
  const LessonProgressDto({
    required this.lessonId,
    required this.isCompleted,
    this.completedAt,
  });

  final String lessonId;
  final bool isCompleted;
  final DateTime? completedAt;

  factory LessonProgressDto.fromMap(Map<String, dynamic> map) {
    return LessonProgressDto(
      lessonId: map['lesson_id'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
      completedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'] as int)
          : null,
    );
  }

  Map<String, dynamic> toMap(String userId) {
    return {
      'user_id': userId,
      'lesson_id': lessonId,
      'is_completed': isCompleted ? 1 : 0,
      'completed_at': completedAt?.millisecondsSinceEpoch,
    };
  }

  LessonProgressDto copyWith({
    String? lessonId,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return LessonProgressDto(
      lessonId: lessonId ?? this.lessonId,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
