import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';

class ShowTicketsEntity {
  final int id;
  final UserEntity user;
  final bool isUser;
  final String title, desc, status, file, fileName, fileExt, createdAt;
  final int fileSize;

  ShowTicketsEntity({
    required this.id,
    required this.user,
    required this.isUser,
    required this.title,
    required this.desc,
    required this.status,
    required this.file,
    required this.fileName,
    required this.fileExt,
    required this.createdAt,
    required this.fileSize,
  });
}
