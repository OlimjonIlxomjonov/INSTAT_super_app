import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_certificate_course_entity.dart';

class UserCertificateEntity {
  final int? id;
  final UserCertificateCourseEntity? course;
  final String? certificateImage;

  const UserCertificateEntity({this.id, this.course, this.certificateImage});


}
