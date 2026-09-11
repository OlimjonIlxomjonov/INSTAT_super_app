import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class MarkNotifReadUseCase {
  final HomeRepository repository;

  MarkNotifReadUseCase({required this.repository});

  Future<void> call(int id) {
    return repository.markNotifAsRead(id);
  }
}

class MarkAllNotifsReadUseCase {
  final HomeRepository repository;

  MarkAllNotifsReadUseCase({required this.repository});

  Future<void> call() {
    return repository.markAllNotifsAsRead();
  }
}
