import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';

class VacancyModel extends VacancyEntity {
  const VacancyModel({
    required super.id,
    super.specialization,
    super.position,
    super.department,
    super.employmentType,
    super.requirements,
    super.responsibilities,
    super.offer,
    super.experience,
    super.expireAt,
    super.quantity,
    super.salaryFrom,
    super.salaryTo,
    super.status,
    super.publishedAt,
    super.createdAt,
  });

  factory VacancyModel.fromJson(Map<String, dynamic> json) {
    return VacancyModel(
      id: json['id'] ?? 0,
      specialization: _ref(json['specialization']),
      position: _ref(json['position']),
      department: _department(json['department']),
      employmentType: json['employment_type'],
      requirements: json['requirements'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
      offer: json['offer'] ?? '',
      experience: json['experience'],
      expireAt: DateTime.tryParse(json['expire_at']?.toString() ?? ''),
      quantity: json['quantity'] ?? 1,
      salaryFrom: (json['salary_from'] as num?)?.toInt(),
      salaryTo: (json['salary_to'] as num?)?.toInt(),
      status: json['status'] ?? '',
      publishedAt: DateTime.tryParse(json['published_at']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  static VacancyRefEntity? _ref(dynamic value) {
    if (value is! Map) return null;
    return VacancyRefEntity(id: value['id'] ?? 0, name: value['name'] ?? '');
  }

  static VacancyDepartmentEntity? _department(dynamic value) {
    if (value is! Map) return null;
    return VacancyDepartmentEntity(
      id: value['id'] ?? 0,
      name: value['name'] ?? '',
    );
  }
}
