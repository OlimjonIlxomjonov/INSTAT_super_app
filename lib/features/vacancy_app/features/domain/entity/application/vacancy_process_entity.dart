class VacancyProcessUserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;

  const VacancyProcessUserEntity({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.avatar,
  });

  String get fullName => '$lastName $firstName'.trim();
}

class VacancyProcessEntity {
  final int id;
  final VacancyProcessUserEntity? user;
  final String status;
  final String? comment;
  final String? address;
  final String? contact;
  final DateTime? assignedAt;
  final bool isLocked;
  final DateTime? createdAt;

  const VacancyProcessEntity({
    required this.id,
    this.user,
    this.status = '',
    this.comment,
    this.address,
    this.contact,
    this.assignedAt,
    this.isLocked = false,
    this.createdAt,
  });
}
