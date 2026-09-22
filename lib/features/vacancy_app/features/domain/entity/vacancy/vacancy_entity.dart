class VacancyRefEntity {
  final int id;
  final String name;

  const VacancyRefEntity({required this.id, required this.name});
}

class VacancyDepartmentEntity {
  final int id;
  final String name;

  const VacancyDepartmentEntity({required this.id, required this.name});
}

class VacancyEntity {
  final int id;
  final VacancyRefEntity? specialization;
  final VacancyRefEntity? position;
  final VacancyDepartmentEntity? department;
  final String? employmentType;
  final String requirements;
  final String responsibilities;
  final String offer;
  final String? experience;
  final DateTime? expireAt;
  final int quantity;
  final int? salaryFrom;
  final int? salaryTo;
  final String status;
  final DateTime? publishedAt;
  final DateTime? createdAt;

  const VacancyEntity({
    required this.id,
    this.specialization,
    this.position,
    this.department,
    this.employmentType,
    this.requirements = '',
    this.responsibilities = '',
    this.offer = '',
    this.experience,
    this.expireAt,
    this.quantity = 1,
    this.salaryFrom,
    this.salaryTo,
    this.status = '',
    this.publishedAt,
    this.createdAt,
  });

  String get title => position?.name ?? '';
  String get subtitle => specialization?.name ?? '';
}
