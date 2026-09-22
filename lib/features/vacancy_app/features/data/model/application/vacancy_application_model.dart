import 'package:my_template/features/vacancy_app/features/data/model/vacancy/vacancy_model.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_entity.dart';

class VacancyCandidateModel extends VacancyCandidateEntity {
  const VacancyCandidateModel({
    required super.id,
    super.firstName,
    super.lastName,
    super.email,
    super.phoneNumber,
    super.birthDate,
    super.avatar,
    super.status,
  });

  factory VacancyCandidateModel.fromJson(Map<String, dynamic> json) {
    return VacancyCandidateModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      birthDate: DateTime.tryParse(json['birth_date']?.toString() ?? ''),
      avatar: json['avatar'],
      status: json['status'] ?? '',
    );
  }
}

class VacancyApplicationModel extends VacancyApplicationEntity {
  const VacancyApplicationModel({
    required super.id,
    super.vacancy,
    super.candidate,
    super.status,
    super.createdAt,
  });

  factory VacancyApplicationModel.fromJson(Map<String, dynamic> json) {
    final vacancy = json['vacancy'];
    final candidate = json['candidate'];
    return VacancyApplicationModel(
      id: json['id'] ?? 0,
      vacancy: vacancy is Map<String, dynamic>
          ? VacancyModel.fromJson(vacancy)
          : null,
      candidate: candidate is Map<String, dynamic>
          ? VacancyCandidateModel.fromJson(candidate)
          : null,
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
