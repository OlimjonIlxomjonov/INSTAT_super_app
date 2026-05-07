import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

class PerCourseUseCase {
  final HomeEduRepository repository;

  PerCourseUseCase({required this.repository});

  Future<CourseEntity> call({required PerCourseParams params}) {
    return repository.getPerCourse(params: params);
  }
}
