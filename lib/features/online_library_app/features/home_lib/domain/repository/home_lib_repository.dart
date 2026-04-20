import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class HomeLibRepository {
  Future<BookListResponse> getPopularBooks();
  Future<void> saveDeleteBook(int id);
  Future<void> addToCart(int id);
}
