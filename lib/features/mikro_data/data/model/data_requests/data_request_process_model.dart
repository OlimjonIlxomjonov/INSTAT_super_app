import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_process_entity.dart';

class DataRequestProcessUserModel extends DataRequestProcessUserEntity {
  const DataRequestProcessUserModel({
    required super.id,
    super.userName,
    super.email,
    super.avatar,
    super.firstName,
    super.lastName,
    super.isVerified,
  });

  static DataRequestProcessUserModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return DataRequestProcessUserModel(
      id: json['id'] ?? 0,
      userName: json['username'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      isVerified: json['is_verified'] ?? false,
    );
  }
}

class DataRequestProcessModel extends DataRequestProcessEntity {
  const DataRequestProcessModel({
    required super.id,
    super.file,
    super.status,
    super.comment,
    super.user,
    super.cycle,
    super.createdAt,
    super.fileSize,
  });

  factory DataRequestProcessModel.fromJson(Map<String, dynamic>? json) {
    return DataRequestProcessModel(
      id: json?['id'] ?? 0,
      file: json?['file'],
      status: json?['status'] ?? '',
      comment: json?['comment'] ?? '',
      user: DataRequestProcessUserModel.fromJson(
        json?['user'] as Map<String, dynamic>?,
      ),
      cycle: json?['cycle'] ?? 1,
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
      fileSize: json?['file_size'],
    );
  }

  static List<DataRequestProcessModel> listFromJson(dynamic json) {
    if (json is! List) return const [];
    return json
        .map(
          (e) => DataRequestProcessModel.fromJson(e as Map<String, dynamic>?),
        )
        .toList();
  }
}
