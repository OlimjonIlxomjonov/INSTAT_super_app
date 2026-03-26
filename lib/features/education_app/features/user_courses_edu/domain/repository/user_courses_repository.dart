import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_category_by_id/course_category_by_id_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_topics/course_lesson_topics_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';

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
}
