import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class RegisterNotResidentUseCase {
  final HomeRepository repository;

  RegisterNotResidentUseCase({required this.repository});

  Future<void> call(RegisterNotResidentParams params) {
    return repository.registerNotResident(params: params);
  }
}
