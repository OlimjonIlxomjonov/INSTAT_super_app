import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_category_by_id/course_category_by_id_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_topics/course_lesson_topics_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/sources/remote_data_source/user_courses_remote_data_source.dart';

class UserCoursesRemoteDataSourceImpl implements UserCoursesRemoteDataSource {
  final _dioClient = DioClient();

  @override
  Future<CourseListResponseModel> fetchUserCourses({
    required UserCoursesParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.userCourses}${params.state}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CourseListResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<CourseCategoryByIdModel> fetchCourseCategoryById({
    required CourseCategoryByIdParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.userCategoryById}${params.id}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CourseCategoryByIdModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<CourseLessonTopicsResponseModel> fetchLessonsTopics({
    required CourseCategoryByIdParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.id}${ApiUrls.lessonsTopic}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CourseLessonTopicsResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
