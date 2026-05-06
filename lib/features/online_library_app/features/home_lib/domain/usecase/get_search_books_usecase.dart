import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class GetSearchBooksUseCase {
  final HomeLibRepository _homeLibRepository;

  GetSearchBooksUseCase({required HomeLibRepository homeLibRepository})
    : _homeLibRepository = homeLibRepository;

  Future<BookListResponse> call(SearchBooksParams params) {
    return _homeLibRepository.searchBooks(params.search, params.page);
  }
}
