class ReviewerLoginRequestModel {
  final String username;
  final String password;

  const ReviewerLoginRequestModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
