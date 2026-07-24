import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class UpdateBookCurrentPageUseCase {
  final HomeLibRepository repository;

  UpdateBookCurrentPageUseCase({required this.repository});

  Future<void> call(UpdateBookCurrentPageParams params) {
    return repository.updateBookCurrentPage(params: params);
  }
}
