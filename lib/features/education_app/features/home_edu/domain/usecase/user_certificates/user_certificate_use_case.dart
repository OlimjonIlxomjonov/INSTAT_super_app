import 'package:my_template/features/education_app/features/home_edu/domain/entity/user_sertificate/user_sertificate_response.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/repository/home_edu_repository.dart';

class UserCertificateUseCase {
  final HomeEduRepository repository;

  UserCertificateUseCase({required this.repository});

  Future<UserCertificateResponse> call() {
    return repository.getUserCertificates();
  }
}
