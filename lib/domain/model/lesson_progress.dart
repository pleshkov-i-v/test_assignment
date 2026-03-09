class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    required this.isCompleted,
    this.completedAt,
  });

  final String lessonId;
  final bool isCompleted;
  final DateTime? completedAt;
}
