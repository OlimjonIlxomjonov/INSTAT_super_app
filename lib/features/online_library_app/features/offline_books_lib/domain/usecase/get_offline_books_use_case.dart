import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/repository/offline_books_repository.dart';

class GetOfflineBooksUseCase {
  final OfflineBooksRepository _repository;

  GetOfflineBooksUseCase({required OfflineBooksRepository repository})
      : _repository = repository;

  Future<BookListResponse> call(SearchBooksParams params) {
    return _repository.fetchOfflineBooks(search: params.search, page: params.page);
  }
}
