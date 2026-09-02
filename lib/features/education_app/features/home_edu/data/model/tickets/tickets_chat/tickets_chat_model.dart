import 'package:my_template/features/education_app/features/home_edu/data/model/tickets/tickets_chat/tickets_chat_user_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_entity.dart';

class TicketsChatModel extends TicketsChatEntity {
  TicketsChatModel({
    required super.id,
    required super.ticket,
    required super.user,
    required super.isUser,
    required super.message,
    required super.fileName,
    required super.fileExt,
    required super.file,
    required super.fileSize,
    required super.createdAt,
  });

  factory TicketsChatModel.fromJson(Map<String, dynamic> json) {
    return TicketsChatModel(
      id: json['id'] ?? 0,
      ticket: json['ticket'] ?? 0,
      user: TicketsChatUserModel.fromJson(json['user']),
      isUser: json['is_user'] ?? false,
      message: json['message'] ?? 'Unknown',
      fileName: json['file_name'] ?? '',
      fileExt: json['file_extension'] ?? '',
      file: json['file'] ?? '',
      fileSize: json['file_size'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
