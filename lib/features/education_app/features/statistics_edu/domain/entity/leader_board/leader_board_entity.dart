class LeaderBoardEntity {
  final int id;
  final String username;
  final String email;
  final String? avatar;
  final String firstName;
  final String lastName;
  final int completedCourseCount;
  final int paidCourseCount;
  final int certificatesCount;
  final int scoreSum;

  LeaderBoardEntity({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    required this.firstName,
    required this.lastName,
    required this.completedCourseCount,
    required this.paidCourseCount,
    required this.certificatesCount,
    required this.scoreSum,
  });

  factory LeaderBoardEntity.empty() => LeaderBoardEntity(
    id: 0,
    username: 'placeholder',
    email: 'placeholder@email.com',
    avatar: null,
    firstName: 'Firstname',
    lastName: 'Lastname',
    scoreSum: 0,
    completedCourseCount: 1,
    paidCourseCount: 1,
    certificatesCount: 1,
  );
}
