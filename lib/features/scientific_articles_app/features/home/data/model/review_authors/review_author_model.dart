import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';

class ReviewAuthorModel extends ReviewAuthorEntity {
  ReviewAuthorModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.review,
    super.academicDegree,
    required super.address,
    required super.organization,
    required super.email,
    required super.phoneNumber,
    required super.orcidCode,
    super.createdAt,
  });

  factory ReviewAuthorModel.fromJson(Map<String, dynamic> json) {
    return ReviewAuthorModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      review: json['review'] ?? 0,
      academicDegree: json['academic_degree'] != null
          ? AcademicDegreeModel.fromJson(json['academic_degree'])
          : null,
      address: json['address'] ?? '',
      organization: json['organization'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      orcidCode: json['orcid_code'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}

class AcademicDegreeModel extends AcademicDegreeEntity {
  AcademicDegreeModel({
    required super.id,
    required super.name,
    required super.isActive,
    super.createdAt,
  });

  factory AcademicDegreeModel.fromJson(Map<String, dynamic> json) {
    return AcademicDegreeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
