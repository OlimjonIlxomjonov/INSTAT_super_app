import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/similar_book/similar_book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class SimilarBooksUseCase {
  final HomeLibRepository repository;

  SimilarBooksUseCase({required this.repository});

  Future<List<SimilarBookEntity>> call(int bookId) =>
      repository.getBooksByCategory(bookId);
}

class BookByIdUseCase {
  final HomeLibRepository repository;

  BookByIdUseCase({required this.repository});

  Future<BookEntity> call(int bookId) => repository.getBookById(bookId);
}
