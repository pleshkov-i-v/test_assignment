import 'package:test_case/domain/model/course.dart';

abstract interface class ICourseRepository {
  Future<Course> getCourse();
}
