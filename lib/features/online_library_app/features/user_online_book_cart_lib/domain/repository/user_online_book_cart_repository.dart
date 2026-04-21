import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class UserOnlineBookCartRepository {
  Future<BookListResponse> getCart();
}
