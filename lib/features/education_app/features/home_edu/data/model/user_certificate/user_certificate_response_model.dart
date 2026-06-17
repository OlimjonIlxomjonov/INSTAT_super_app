import 'package:my_template/features/education_app/features/home_edu/data/model/user_certificate/user_certificate_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_response.dart';

import '../../../../../../main_app/home/data/model/pagination/links/lniks_model.dart';
import '../../../../../../main_app/home/data/model/pagination/meta/meta_model.dart';

class UserCertificateResponseModel extends UserCertificateResponse {
  UserCertificateResponseModel({super.links, required super.data, super.meta});

  factory UserCertificateResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserCertificateResponseModel(data: []);
    }

    return UserCertificateResponseModel(
      links: json['links'] != null ? LinksModel.fromJson(json['links']) : null,
      data:
          (json['data'] as List?)
              ?.map((e) => UserCertificateModel.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? MetaModel.fromJson(json['meta']) : null,
    );
  }
}
