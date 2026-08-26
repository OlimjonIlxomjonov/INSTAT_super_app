import 'package:my_template/features/auth/domain/repository/reviewer_auth_repository.dart';

class ReviewerLoginUseCase {
  final ReviewerAuthRepository repository;

  ReviewerLoginUseCase({required this.repository});

  Future<void> call({
    required String username,
    required String password,
  }) {
    return repository.login(username: username, password: password);
  }
}
