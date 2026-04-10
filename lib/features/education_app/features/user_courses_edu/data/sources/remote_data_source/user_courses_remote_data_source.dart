import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/about_course_features/about_course_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/check_final_test_access_model/check_final_test_access_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_category_by_id/course_category_by_id_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_files/course_files_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_topics/course_lesson_topics_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_items/course_lesson_items_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_test/lesson_test_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_test/lesson_test_option_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/course_lesson_test/lesson_test_answer_response_model.dart';

abstract class UserCoursesRemoteDataSource {
  Future<CourseListResponseModel> fetchUserCourses({
    required UserCoursesParams params,
  });

  Future<CourseCategoryByIdModel> fetchCourseCategoryById({
    required CourseCategoryByIdParams params,
  });

  Future<CourseLessonTopicsResponseModel> fetchLessonsTopics({
    required CourseCategoryByIdParams params,
  });

  Future<CourseLessonItemsResponseModel> fetchCourseLessonItems({
    required CourseLessonItemsParams params,
  });

  Future<AboutCourseResponseModel> fetchAboutCourseFeatures({
    required CourseCategoryByIdParams params,
  });

  Future<List<CourseFilesModel>> fetchCourseFiles({
    required CourseFilesParams params,
  });

  Future<void> postBoughtCourses({required BuyCourseParams params});

  Future<CourseListResponseModel> fetchSearchCourses({
    required SearchCoursesParams params,
  });

  Future<List<LessonTestModel>> fetchLessonTests({
    required CourseLessonTestParams params,
  });

  Future<List<LessonTestOptionModel>> fetchLessonTestOptions({
    required CourseLessonTestOptionsParams params,
  });

  Future<LessonTestAnswerResponseModel> postSubmitLessonTestAnswer({
    required SubmitLessonTestAnswerParams params,
  });

  Future<CheckFinalTestAccessModel> postCheckFinalTestAccess({
    required CheckFinalTestAccessParams params,
  });
}
