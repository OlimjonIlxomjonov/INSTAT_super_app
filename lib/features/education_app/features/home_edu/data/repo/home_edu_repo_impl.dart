import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/source/remote_data_source/home_edu_remote_data_source.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class HomeEduRepoImpl implements HomeEduRepository {
  final HomeEduRemoteDataSource _remoteDataSource;

  HomeEduRepoImpl({required HomeEduRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<CommentsResponse> getComments({required CommentsParams params}) {
    return _remoteDataSource.fetchComments(params: params);
  }
}
