import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';

abstract class HomeEduRemoteDataSource {
  Future<CommentsResponseModel> fetchComments({required CommentsParams params});
}
