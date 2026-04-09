import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/check_final_test_access/check_final_test_access_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class CheckFinalTestAccessUseCase {
  final UserCoursesRepository repository;

  CheckFinalTestAccessUseCase({required this.repository});

  Future<CheckFinalTestAccessEntity> call({
    required CheckFinalTestAccessParams params,
  }) {
    return repository.checkFinalTestAccess(params: params);
  }
}
