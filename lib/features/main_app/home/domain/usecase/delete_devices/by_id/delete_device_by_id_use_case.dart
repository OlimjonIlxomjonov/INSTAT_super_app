import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class DeleteDeviceByIdUseCase {
  final HomeRepository repository;

  DeleteDeviceByIdUseCase({required this.repository});

  Future<void> call(int id) {
    return repository.deleteDeviceById(id);
  }
}
