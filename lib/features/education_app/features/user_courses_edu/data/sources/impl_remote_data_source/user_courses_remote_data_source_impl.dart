import 'package:dio/dio.dart';
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
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_offline_lessons/course_offline_lessons_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/offline_course/offline_course_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/order_payment/order_payment_model.dart';
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
  Future<OrderPaymentModel> postBoughtCourses({
    required BuyCourseParams params,
  }) async {
    try {
      final response = await _dioClient.post(
        "${ApiUrls.courses}/${params.courseId}/order/",
        data: {"payment_method": params.paymentMethod},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return OrderPaymentModel.fromJson(data);
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
      final requestData = <String, dynamic>{"lesson_test_option": params.optionId};
      final image = params.image;
      if (image != null) {
        requestData["image"] = image;
      }

      final response = await _dioClient.post(
        "${ApiUrls.courses}${params.courseId}/course_blocks/${params.blockId}/lessons/${params.lessonId}/lesson_tests/${params.testId}/answer/",
        data: requestData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return LessonTestAnswerResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Parse error response from DioException (e.g., 400 validation errors)
      String? extractedError;

      if (e.response != null) {
        try {
          final errorData = e.response!.data;
          if (errorData is Map && errorData['error'] != null) {
            final error = errorData['error'];
            if (error is Map && error['details'] is List) {
              final details = error['details'] as List;
              if (details.isNotEmpty) {
                extractedError = details[0];
              }
            }
          }
        } catch (parseError) {
          // If parsing fails, extracted error stays null
        }
      }

      logger.e(e);
      if (extractedError != null) {
        throw Exception(extractedError);
      }
      rethrow;
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
      final body = <String, dynamic>{"course_test_option": params.optionId};
      if (params.image != null) {
        body["image"] = params.image;
      }

      final response = await _dioClient.post(
        "${ApiUrls.courses}${params.courseId}/course_tests/${params.testId}/answer/",
        data: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        logger.i(data);
        return LessonTestAnswerResponseModel.fromJson(data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Parse error response from DioException (e.g., 400 validation errors)
      String? extractedError;

      if (e.response != null) {
        try {
          final errorData = e.response!.data;
          if (errorData is Map && errorData['error'] != null) {
            final error = errorData['error'];
            if (error is Map && error['details'] is List) {
              final details = error['details'] as List;
              if (details.isNotEmpty) {
                extractedError = details[0];
              }
            }
          }
        } catch (parseError) {
          // If parsing fails, extracted error stays null
        }
      }

      logger.e(e);
      if (extractedError != null) {
        throw Exception(extractedError);
      }
      rethrow;
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

  //! scan qr
  @override
  Future<void> scanQr({required ScanQrParams params}) async {
    try {
      final response = await _dioClient.post(
        "${ApiUrls.courseGroups}${params.id}${ApiUrls.courseGroupDates}${params.groupId}/${ApiUrls.scanQr}",
        data: {"qr_code_str": params.barCode},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<List<CourseOfflineLessonsModel>> fetchOfflineLessons({
    required OfflineLessonsParams params,
  }) async {
    try {
      final response = await _dioClient.get(
        "${ApiUrls.courseGroups}${params.id}${ApiUrls.courseGroupDates}${params.groupId}/${ApiUrls.offlineLessons}",
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i(response.data);
        final data = response.data as List;
        return data.map((e) => CourseOfflineLessonsModel.fromJson(e)).toList();
      } else {
        throw Exception('ERROR ${response.statusCode}');
      }
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
