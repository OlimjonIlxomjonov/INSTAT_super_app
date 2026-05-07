import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/table_edu/data/source/remote_data_source/course_group_dates_remote_data_source.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/entity/course_group_date_entity.dart';
import 'package:my_template/features/education_app/features/table_edu/domain/repository/course_group_dates_repository.dart';

class CourseGroupDatesRepoImpl implements CourseGroupDatesRepository {
  final CourseGroupDatesRemoteDataSource _remoteDataSource;

  CourseGroupDatesRepoImpl({
    required CourseGroupDatesRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CourseGroupDateEntity>> getCourseGroupDates({
    required CourseGroupDateParams params,
  }) {
    return _remoteDataSource.fetchCourseGroupDates(params: params);
  }
}
