abstract class ReviewerLoginState {
  const ReviewerLoginState();
}

class ReviewerLoginInitial extends ReviewerLoginState {}

class ReviewerLoginLoading extends ReviewerLoginState {}

class ReviewerLoginSuccess extends ReviewerLoginState {}

class ReviewerLoginError extends ReviewerLoginState {
  final String message;
  final int? statusCode;

  const ReviewerLoginError({
    required this.message,
    this.statusCode,
  });
}
