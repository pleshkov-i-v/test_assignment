class CourseLessonItem {
  const CourseLessonItem({
    required this.id,
    required this.title,
    required this.order,
    required this.isLocked,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final int order;
  final bool isLocked;
  final bool isCompleted;
}
