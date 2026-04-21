import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/repository/user_online_book_cart_repository.dart';

class CartUseCase {
  final UserOnlineBookCartRepository repository;

  CartUseCase({required this.repository});

  Future<BookListResponse> call() {
    return repository.getCart();
  }
}
