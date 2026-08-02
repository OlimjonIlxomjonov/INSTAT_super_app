import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class GetPopularBooksUseCase {
  final HomeLibRepository repository;

  GetPopularBooksUseCase({required this.repository});

  Future<BookListResponse> call({int page = 1}) {
    return repository.getPopularBooks(page: page);
  }
}
