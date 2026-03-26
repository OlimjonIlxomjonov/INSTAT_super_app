import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class CourseCategoryByIdUseCase {
  final UserCoursesRepository repository;

  CourseCategoryByIdUseCase({required this.repository});

  Future<CourseCategoryByIdEntity> call({
    required CourseCategoryByIdParams params,
  }) {
    return repository.getCourseCategoryById(params: params);
  }
}
