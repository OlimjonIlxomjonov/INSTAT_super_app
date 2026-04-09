import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/check_final_test_access/check_final_test_access_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/sources/remote_data_source/user_courses_remote_data_source.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_files_entity/course_file_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/repository/user_courses_repository.dart';

class UserCoursesRepoImpl implements UserCoursesRepository {
  final UserCoursesRemoteDataSource _remoteDataSource;

  UserCoursesRepoImpl({required UserCoursesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<CourseListResponse> getUserCourses({
    required UserCoursesParams params,
  }) {
    return _remoteDataSource.fetchUserCourses(params: params);
  }

  @override
  Future<CourseCategoryByIdEntity> getCourseCategoryById({
    required CourseCategoryByIdParams params,
  }) {
    return _remoteDataSource.fetchCourseCategoryById(params: params);
  }

  @override
  Future<CourseLessonTopicsResponse> getLessonTopics({
    required CourseCategoryByIdParams params,
  }) {
    return _remoteDataSource.fetchLessonsTopics(params: params);
  }

  @override
  Future<CourseLessonItemsResponseEntity> getCourseLessonItems({
    required CourseLessonItemsParams params,
  }) {
    return _remoteDataSource.fetchCourseLessonItems(params: params);
  }

  @override
  Future<AboutCourseResponse> getAboutCourseFeatures({
    required CourseCategoryByIdParams params,
  }) {
    return _remoteDataSource.fetchAboutCourseFeatures(params: params);
  }

  @override
  Future<List<CourseFileEntity>> getCourseFiles({
    required CourseFilesParams params,
  }) {
    return _remoteDataSource.fetchCourseFiles(params: params);
  }

  @override
  Future<void> postBuyCourse({required BuyCourseParams params}) {
    return _remoteDataSource.postBoughtCourses(params: params);
  }

  @override
  Future<CourseListResponse> searchCourses({
    required SearchCoursesParams params,
  }) {
    return _remoteDataSource.fetchSearchCourses(params: params);
  }

  @override
  Future<List<LessonTestEntity>> getLessonTests({
    required CourseLessonTestParams params,
  }) {
    return _remoteDataSource.fetchLessonTests(params: params);
  }

  @override
  Future<List<LessonTestOptionEntity>> getLessonTestOptions({
    required CourseLessonTestOptionsParams params,
  }) {
    return _remoteDataSource.fetchLessonTestOptions(params: params);
  }

  @override
  Future<LessonTestAnswerResponseEntity> submitLessonTestAnswer({
    required SubmitLessonTestAnswerParams params,
  }) {
    return _remoteDataSource.postSubmitLessonTestAnswer(params: params);
  }

  @override
  Future<CheckFinalTestAccessModel> checkFinalTestAccess({
    required CheckFinalTestAccessParams params,
  }) {
    return _remoteDataSource.postCheckFinalTestAccess(params: params);
  }
}
