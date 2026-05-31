class ReviewAuthorEntity {
  final int id;
  final String firstName;
  final String lastName;
  final int review;
  final AcademicDegreeEntity? academicDegree;
  final String address;
  final String organization;
  final String email;
  final String phoneNumber;
  final String orcidCode;
  final DateTime? createdAt;

  const ReviewAuthorEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.review,
    this.academicDegree,
    required this.address,
    required this.organization,
    required this.email,
    required this.phoneNumber,
    required this.orcidCode,
    this.createdAt,
  });
}

class AcademicDegreeEntity {
  final int id;
  final String name;
  final bool isActive;
  final DateTime? createdAt;

  const AcademicDegreeEntity({
    required this.id,
    required this.name,
    required this.isActive,
    this.createdAt,
  });
}
