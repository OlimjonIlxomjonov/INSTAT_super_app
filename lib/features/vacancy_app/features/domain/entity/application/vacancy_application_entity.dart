import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';

class VacancyCandidateEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime? birthDate;
  final String? avatar;
  final String status;

  const VacancyCandidateEntity({
    required this.id,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phoneNumber = '',
    this.birthDate,
    this.avatar,
    this.status = '',
  });

  String get fullName => '$lastName $firstName'.trim();
}

class VacancyApplicationEntity {
  final int id;
  final VacancyEntity? vacancy;
  final VacancyCandidateEntity? candidate;
  final String status;
  final DateTime? createdAt;

  const VacancyApplicationEntity({
    required this.id,
    this.vacancy,
    this.candidate,
    this.status = '',
    this.createdAt,
  });
}
