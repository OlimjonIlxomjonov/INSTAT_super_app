import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_process_entity.dart';

class VacancyProcessModel extends VacancyProcessEntity {
  const VacancyProcessModel({
    required super.id,
    super.user,
    super.status,
    super.comment,
    super.address,
    super.contact,
    super.assignedAt,
    super.isLocked,
    super.createdAt,
  });

  factory VacancyProcessModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return VacancyProcessModel(
      id: json['id'] ?? 0,
      user: user is Map
          ? VacancyProcessUserEntity(
              id: user['id'] ?? 0,
              firstName: user['first_name'] ?? '',
              lastName: user['last_name'] ?? '',
              email: user['email'] ?? '',
              avatar: user['avatar'],
            )
          : null,
      status: json['status'] ?? '',
      comment: json['comment'],
      address: json['address'],
      contact: json['contact'],
      assignedAt: DateTime.tryParse(json['assigned_at']?.toString() ?? ''),
      isLocked: json['is_locked'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
