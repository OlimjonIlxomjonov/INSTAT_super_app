import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_page_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class FetchBookPagesUseCase {
  final HomeLibRepository repository;

  FetchBookPagesUseCase({required this.repository});

  Future<List<BookPageEntity>> call(BookPagesParams params) {
    return repository.getBookPages(params: params);
  }
}
