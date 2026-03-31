import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_files_entity/course_file_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class CourseFilesUseCase {
  final UserCoursesRepository repository;

  CourseFilesUseCase({required this.repository});

  Future<List<CourseFileEntity>> call({required CourseFilesParams params}) {
    return repository.getCourseFiles(params: params);
  }
}
