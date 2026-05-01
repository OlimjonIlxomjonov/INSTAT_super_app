import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';

abstract class HomeEduRepository {
  Future<CommentsResponse> getComments({required CommentsParams params});
}
