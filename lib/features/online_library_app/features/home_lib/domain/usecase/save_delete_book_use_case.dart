import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class SaveDeleteBookUseCase {
  final HomeLibRepository repository;

  SaveDeleteBookUseCase({required this.repository});

  Future<void> call(int id) {
    return repository.saveDeleteBook(id);
  }
}
