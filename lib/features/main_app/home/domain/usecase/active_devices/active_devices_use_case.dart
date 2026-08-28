import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class ActiveDevicesUseCase {
  final HomeRepository repository;

  ActiveDevicesUseCase({required this.repository});

  Future<List<ActiveDevicesEntity>> call() {
    return repository.getActiveDevices();
  }
}
