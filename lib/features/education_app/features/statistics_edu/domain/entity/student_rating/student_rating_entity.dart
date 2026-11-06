class StudentRatingCertificateEntity {
  final int id;
  final String courseName;
  final String? imageUrl;

  const StudentRatingCertificateEntity({
    required this.id,
    required this.courseName,
    this.imageUrl,
  });
}

class StudentRatingEntity {
  final int? rank;
  final double scoreSum;
  final int completedCourseCount;
  final int activeCourseCount;
  final double completionRate;
  final double studyHours;
  final int certificatesCount;
  final List<StudentRatingCertificateEntity> certificates;

  const StudentRatingEntity({
    this.rank,
    required this.scoreSum,
    required this.completedCourseCount,
    required this.activeCourseCount,
    required this.completionRate,
    required this.studyHours,
    required this.certificatesCount,
    required this.certificates,
  });
}
