import 'package:my_template/features/main_app/home/domain/entity/notifications_count/notifications_count_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class NotificationsCountUseCase {
  final HomeRepository repository;

  NotificationsCountUseCase({required this.repository});

  Future<NotificationsCountEntity> call() {
    return repository.getNotifCount();
  }
}
