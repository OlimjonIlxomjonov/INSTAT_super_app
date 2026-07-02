import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/course_list_response.dart';
import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity> getUserMe() {
    return _remoteDataSource.fetchUserMe();
  }

  @override
  Future<CourseListResponse> getActiveCourses() {
    return _remoteDataSource.fetchCourses();
  }

  @override
  Future<void> postAvatar({required AvatarParams params}) {
    return _remoteDataSource.postModelAvatar(params: params);
  }

  @override
  Future<void> faceRecognition({required FaceRecParams params}) {
    return _remoteDataSource.faceRec(params: params);
  }
}
