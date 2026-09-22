import 'dart:io';

class VacancyApplicationListParams {
  final String search;
  final String? status;
  final int? vacancyId;
  final int page;

  const VacancyApplicationListParams({
    this.search = '',
    this.status,
    this.vacancyId,
    this.page = 1,
  });
}

class ApplyVacancyParams {
  final int vacancyId;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String phoneNumber;
  final String email;
  final List<File> files;

  const ApplyVacancyParams({
    required this.vacancyId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.phoneNumber,
    required this.email,
    required this.files,
  });
}
