import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_response.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class NotifUseCase {
  final HomeRepository repository;

  NotifUseCase({required this.repository});

  Future<NotifResponse> call({required NotifParams params}) {
    return repository.getNotifs(params: params);
  }
}
