import 'package:my_template/features/auth/data/models/reviewer_login_request_model.dart';

abstract class ReviewerAuthRemoteDataSource {
  Future<void> login(ReviewerLoginRequestModel params);
}
