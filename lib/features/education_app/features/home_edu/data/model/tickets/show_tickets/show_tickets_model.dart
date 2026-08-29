import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_entity.dart';

import '../../../../../../../main_app/home/data/model/user_me/user_model.dart';

class ShowTicketsModel extends ShowTicketsEntity {
  ShowTicketsModel({
    required super.id,
    required super.user,
    required super.isUser,
    required super.title,
    required super.desc,
    required super.status,
    required super.file,
    required super.fileName,
    required super.fileExt,
    required super.createdAt,
    required super.fileSize,
  });

  factory ShowTicketsModel.fromJson(Map<String, dynamic> json) {
    return ShowTicketsModel(
      id: json['id'] ?? 0,
      user: UserModel.fromJson(json['user']),
      isUser: json['is_user'] ?? false,
      title: json['title'] ?? 'Unknown',
      desc: json['description'] ?? 'Unknown',
      status: json['status'] ?? '',
      file: json['file'] ?? '',
      fileName: json['file_name'] ?? '',
      fileExt: json['file_extension'] ?? '',
      createdAt: json['created_at'] ?? '',
      fileSize: json['file_size'] ?? '',
    );
  }
}
