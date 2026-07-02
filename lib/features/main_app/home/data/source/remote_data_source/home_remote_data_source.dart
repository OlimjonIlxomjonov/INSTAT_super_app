import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/courses/course_list_response_model.dart';
import 'package:my_template/features/main_app/home/data/model/user_me/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> fetchUserMe();

  Future<CourseListResponseModel> fetchCourses();

  Future<void> postModelAvatar({required AvatarParams params});

  //! face rec
  Future<void> faceRec({required FaceRecParams params});
}
