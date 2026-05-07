import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/entity/course_group_date_entity.dart';

abstract class CourseGroupDatesRepository {
  Future<List<CourseGroupDateEntity>> getCourseGroupDates({
    required CourseGroupDateParams params,
  });
}
