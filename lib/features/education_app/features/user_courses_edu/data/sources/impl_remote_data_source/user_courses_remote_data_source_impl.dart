import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/network/dio_client.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/about_course_features/about_course_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/check_final_test_access_model/check_final_test_access_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_category_by_id/course_category_by_id_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_files/course_files_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_items/course_lesson_items_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_test/lesson_test_answer_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_test/lesson_test_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_test/lesson_test_option_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_topics/course_lesson_topics_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/offline_course/offline_course_response_model.dart';
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
        "${ApiUrls.courses}${params.id}${ApiUrls.lessonsTopic}", //  course_blocks/items/all/ # right after params.id
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CourseLessonTopicsResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e, t) {
      logger.e(e);
      logger.e(t);
      rethrow;
    }
  }

  @override
  Future<CourseLessonItemsResponseModel> fetchCourseLessonItems({
    required CourseLessonItemsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/course_blocks/${params.blockId}${ApiUrls.lessonItems}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CourseLessonItemsResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<AboutCourseResponseModel> fetchAboutCourseFeatures({
    required CourseCategoryByIdParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "courses/${params.id}${ApiUrls.aboutCourseFeatures}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return AboutCourseResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<CourseFilesModel>> fetchCourseFiles({
    required CourseFilesParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/course_blocks/${params.topicId}/lessons/${params.lessonId}/lesson_files/",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        logger.i(data);
        return data.map((e) => CourseFilesModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> postBoughtCourses({required BuyCourseParams params}) async {
    try {
      final response = await _dioClient.post(
        "${ApiUrls.courses}/${params.courseId}/order/",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<CourseListResponseModel> fetchSearchCourses({
    required SearchCoursesParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.availableCourses,
        queryParams: {'search': params.search, 'page': params.page},
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

  /// Regular lesson tests
  // 1
  @override
  Future<List<LessonTestModel>> fetchLessonTests({
    required CourseLessonTestParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/course_blocks/${params.blockId}/lessons/${params.lessonId}/lesson_tests/",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        logger.i(data);
        return data.map((e) => LessonTestModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  // 2
  @override
  Future<List<LessonTestOptionModel>> fetchLessonTestOptions({
    required CourseLessonTestOptionsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/course_blocks/${params.blockId}/lessons/${params.lessonId}/lesson_tests/${params.testId}/lesson_test_options/",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        logger.i(data);
        return data.map((e) => LessonTestOptionModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  // 3
  @override
  Future<LessonTestAnswerResponseModel> postSubmitLessonTestAnswer({
    required SubmitLessonTestAnswerParams params,
  }) async {
    try {
      final response = await _dioClient.post(
        "${ApiUrls.courses}${params.courseId}/course_blocks/${params.blockId}/lessons/${params.lessonId}/lesson_tests/${params.testId}/answer/",
        data: {"lesson_test_option": params.optionId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return LessonTestAnswerResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  /// check is user has access to the course final test
  @override
  Future<CheckFinalTestAccessModel> postCheckFinalTestAccess({
    required CheckFinalTestAccessParams params,
  }) async {
    try {
      final response = await _dioClient.post(
        '${ApiUrls.courses}${params.courseId}${ApiUrls.checkCourseTestAccess}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return CheckFinalTestAccessModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  /// final course tests
  @override
  Future<List<LessonTestModel>> fetchFinalCourseTest({
    required CourseLessonTestParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/course_tests/",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        logger.i(data);
        return data.map((e) => LessonTestModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<LessonTestOptionModel>> fetchFinalCourseTestOptions({
    required CourseLessonTestOptionsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courses}${params.courseId}/course_tests/${params.testId}/course_test_options/",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List;
        logger.i(data);
        return data.map((e) => LessonTestOptionModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<LessonTestAnswerResponseModel> postSubmitFinalTestAnswer({
    required SubmitLessonTestAnswerParams params,
  }) async {
    try {
      final response = await _dioClient.post(
        "${ApiUrls.courses}${params.courseId}/course_tests/${params.testId}/answer/",
        data: {"course_test_option": params.optionId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return LessonTestAnswerResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> putLessonVideoProgress({
    required LessonVideoProgressParams params,
  }) async {
    try {
      final response = await _dioClient.put(
        "lessons/${params.lessonId}/progress",
        data: {"progress": params.progress},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        logger.f(params.progress);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  /// offline course
  @override
  Future<OfflineCourseResponseModel> fetchOfflineCourse() async {
    try {
      final response = await _dioClient.get(ApiUrls.offlineCourse);
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        return OfflineCourseResponseModel.fromJson(response.data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
