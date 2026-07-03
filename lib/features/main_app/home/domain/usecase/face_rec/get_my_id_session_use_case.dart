import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class GetMyIdSessionUseCase {
  final HomeRepository repository;

  GetMyIdSessionUseCase({required this.repository});

  Future<String> call({
    required String birthDate,
    required String passportData,
  }) {
    return repository.getMyIdSessionId(
      birthDate: birthDate,
      passportData: passportData,
    );
  }
}
