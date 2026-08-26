abstract class ReviewerAuthRepository {
  Future<void> login({
    required String username,
    required String password,
  });
}
