import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class DeleteAllDevicesUseCase {
  final HomeRepository repository;

  DeleteAllDevicesUseCase({required this.repository});

  Future<void> call() {
    return repository.deleteAllDevices();
  }
}
