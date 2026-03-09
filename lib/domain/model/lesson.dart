import 'package:test_case/domain/model/exercise.dart';

class Lesson {
  const Lesson({
    required this.id,
    required this.order,
    required this.title,
    required this.exercises,
  });

  final String id;
  final int order;
  final String title;
  final List<Exercise> exercises;
}
