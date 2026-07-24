import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_pages_count_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class FetchBookPagesCountUseCase {
  final HomeLibRepository repository;

  FetchBookPagesCountUseCase({required this.repository});

  Future<BookPagesCountEntity> call(int bookId) {
    return repository.getBookPagesCount(bookId);
  }
}
