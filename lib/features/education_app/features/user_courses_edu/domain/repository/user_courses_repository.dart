import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/check_final_test_access_model/check_final_test_access_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/about_course_features/about_this_course_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/check_final_test_access/check_final_test_access_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_files_entity/course_file_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_response_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_answer_response_entity.dart';

abstract class UserCoursesRepository {
  Future<CourseListResponse> getUserCourses({
    required UserCoursesParams params,
  });

  Future<CourseCategoryByIdEntity> getCourseCategoryById({
    required CourseCategoryByIdParams params,
  });

  Future<CourseLessonTopicsResponse> getLessonTopics({
    required CourseCategoryByIdParams params, // course lesson topics ID
  });

  Future<CourseLessonItemsResponseEntity> getCourseLessonItems({
    required CourseLessonItemsParams params,
  });

  Future<AboutCourseResponse> getAboutCourseFeatures({
    required CourseCategoryByIdParams params,
  });

  Future<List<CourseFileEntity>> getCourseFiles({
    required CourseFilesParams params,
  });

  Future<void> postBuyCourse({required BuyCourseParams params});

  Future<CourseListResponse> searchCourses({
    required SearchCoursesParams params,
  });

  Future<List<LessonTestEntity>> getLessonTests({
    required CourseLessonTestParams params,
  });

  Future<List<LessonTestOptionEntity>> getLessonTestOptions({
    required CourseLessonTestOptionsParams params,
  });

  Future<LessonTestAnswerResponseEntity> submitLessonTestAnswer({
    required SubmitLessonTestAnswerParams params,
  });

  Future<CheckFinalTestAccessEntity> checkFinalTestAccess({
    required CheckFinalTestAccessParams params,
  });
}
