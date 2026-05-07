import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/table_edu/data/model/course_group_date_model.dart';
import 'package:my_template/features/education_app/features/table_edu/data/source/remote_data_source/course_group_dates_remote_data_source.dart';

class CourseGroupDatesRemoteDataSourceImpl
    implements CourseGroupDatesRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<List<CourseGroupDateModel>> fetchCourseGroupDates({
    required CourseGroupDateParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.courseGroups}${params.courseGroupId}${ApiUrls.courseGroupDates}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        logger.i(data);
        return data
            .map((e) => CourseGroupDateModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
