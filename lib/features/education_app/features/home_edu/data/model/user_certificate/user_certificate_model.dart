import 'package:my_template/features/education_app/features/home_edu/data/model/user_certificate/user_certificate_course_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_entity.dart';

class UserCertificateModel extends UserCertificateEntity {
  UserCertificateModel({super.certificateImage, super.course, super.id});

  factory UserCertificateModel.fromJson(Map<String, dynamic> json) {
    return UserCertificateModel(
      id: json['id'] as int?,
      course: json['course'] != null
          ? UserCertificateCourseModel.fromJson(json['course'])
          : null,
      certificateImage: json['certificate_image'] as String?,
    );
  }
}
