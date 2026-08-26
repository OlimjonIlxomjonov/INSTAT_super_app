import 'package:my_template/features/auth/data/models/reviewer_login_request_model.dart';
import 'package:my_template/features/auth/data/sources/remote_data_source/reviewer_auth_remote_data_source.dart';
import 'package:my_template/features/auth/domain/repository/reviewer_auth_repository.dart';

class ReviewerAuthRepoImpl implements ReviewerAuthRepository {
  final ReviewerAuthRemoteDataSource _remoteDataSource;

  ReviewerAuthRepoImpl({
    required ReviewerAuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) {
    final params = ReviewerLoginRequestModel(
      username: username,
      password: password,
    );
    return _remoteDataSource.login(params);
  }
}
