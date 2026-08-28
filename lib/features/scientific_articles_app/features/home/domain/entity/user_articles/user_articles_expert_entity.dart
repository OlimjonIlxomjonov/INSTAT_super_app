class UserArticlesExpertEntity {
  final int id;
  final String userName;
  final String email;
  final String? avatar;
  final String firstName;
  final String lastName;

  UserArticlesExpertEntity({
    required this.id,
    required this.userName,
    required this.email,
    this.avatar,
    required this.firstName,
    required this.lastName,
  });
}
