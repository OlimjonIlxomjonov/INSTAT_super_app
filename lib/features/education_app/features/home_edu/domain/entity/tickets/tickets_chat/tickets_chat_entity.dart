import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/tickets_chat/tickets_chat_user.dart';

class TicketsChatEntity {
  final int id, ticket;
  final TicketsChatUserEntity user;
  final bool isUser;
  final String message, fileName, fileExt;
  final String? file;
  final int? fileSize;
  final String createdAt;

  TicketsChatEntity({
    required this.id,
    required this.ticket,
    required this.user,
    required this.isUser,
    required this.message,
    required this.fileName,
    required this.fileExt,
    required this.file,
    required this.fileSize,
    required this.createdAt,
  });
}
