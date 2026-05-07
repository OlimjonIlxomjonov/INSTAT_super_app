import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

abstract class HomeEduRemoteDataSource {
  Future<CommentsResponseModel> fetchComments({required CommentsParams params});

  Future<CourseEntity> fetchPerCourse({required PerCourseParams params});
}
