import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class UserCertificateResponse {
  final Links? links;
  final List<UserCertificateEntity> data;
  final Meta? meta;

  UserCertificateResponse({this.links, required this.data, this.meta});
}
