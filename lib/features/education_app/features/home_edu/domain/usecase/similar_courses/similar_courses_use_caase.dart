import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class SimilarCoursesUseCase {
  final HomeEduRepository repository;

  SimilarCoursesUseCase({required this.repository});

  Future<List<CourseEntity>> call({required PerCourseParams params}) {
    return repository.getSimilarCourses(params: params);
  }
}
