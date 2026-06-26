import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

import '../../entity/course_offline_lessons_entity/course_offline_lessons_entity.dart';

class OfflineLessonsUseCase {
  final UserCoursesRepository repository;

  OfflineLessonsUseCase({required this.repository});

  Future<List<CourseOfflineLessonsEntity>> call({
    required OfflineLessonsParams params,
  }) {
    return repository.getOfflineLessons(params: params);
  }
}
