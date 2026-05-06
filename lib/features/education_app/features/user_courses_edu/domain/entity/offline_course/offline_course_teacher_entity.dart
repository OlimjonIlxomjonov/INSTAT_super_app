class OfflineCourseTeacherEntity {
  final int id;
  final String username;
  final String email;
  final String? avatar;
  final String firstName;
  final String lastName;

  OfflineCourseTeacherEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    required this.firstName,
    required this.lastName,
  });



  String get fullName => '$firstName $lastName';
}