import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/table_edu/data/model/course_group_date_model.dart';

abstract class CourseGroupDatesRemoteDataSource {
  Future<List<CourseGroupDateModel>> fetchCourseGroupDates({
    required CourseGroupDateParams params,
  });
}
