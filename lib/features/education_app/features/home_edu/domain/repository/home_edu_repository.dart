import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_response.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

abstract class HomeEduRepository {
  Future<CommentsResponse> getComments({required CommentsParams params});

  Future<CourseEntity> getPerCourse({required PerCourseParams params});

  //? User Certificates
  Future<UserCertificateResponse> getUserCertificates();

  //? Similar Courses
  Future<List<CourseEntity>> getSimilarCourses({
    required PerCourseParams params,
  });
}
