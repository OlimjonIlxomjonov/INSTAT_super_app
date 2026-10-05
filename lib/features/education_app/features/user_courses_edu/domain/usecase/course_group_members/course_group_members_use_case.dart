import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_group_member/course_group_member_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class CourseGroupDateMembersUseCase {
  final UserCoursesRepository repository;

  CourseGroupDateMembersUseCase({required this.repository});

  Future<List<CourseGroupMemberEntity>> call({
    required OfflineLessonsParams params,
  }) {
    return repository.getCourseGroupDateMembers(params: params);
  }
}
