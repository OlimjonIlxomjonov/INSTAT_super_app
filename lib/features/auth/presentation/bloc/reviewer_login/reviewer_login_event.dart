abstract class ReviewerLoginEvent {
  const ReviewerLoginEvent();
}

class SubmitReviewerLoginEvent extends ReviewerLoginEvent {
  final String username;
  final String password;

  const SubmitReviewerLoginEvent({
    required this.username,
    required this.password,
  });
}
