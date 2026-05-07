class CourseGroupDateEntity {
  final int id;
  final int courseGroup;
  final DateTime dateTime;
  final int lessonsCount;
  final int attendanceCount;

  const CourseGroupDateEntity({
    required this.id,
    required this.courseGroup,
    required this.dateTime,
    required this.lessonsCount,
    required this.attendanceCount,
  });
}
