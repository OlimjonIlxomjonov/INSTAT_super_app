import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';

abstract class HomeRepository {
  Future<UserEntity> getUserMe();

  Future<CourseListResponse> getActiveCourses();

  /// pick the avatar
  Future<void> postAvatar({required AvatarParams params});

  //! Face Recognition
  Future<void> faceRecognition({required FaceRecParams params});
}
