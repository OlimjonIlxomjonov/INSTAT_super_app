import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/entity/course_group_date_entity.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/repository/course_group_dates_repository.dart';

class GetCourseGroupDatesUseCase {
  final CourseGroupDatesRepository repository;

  GetCourseGroupDatesUseCase({required this.repository});

  Future<List<CourseGroupDateEntity>> call({
    required CourseGroupDateParams params,
  }) {
    return repository.getCourseGroupDates(params: params);
  }
}
