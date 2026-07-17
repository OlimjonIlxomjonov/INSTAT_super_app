import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/order_payment/order_payment_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class UserOnlineBookCartRepository {
  Future<BookListResponse> getCart();

  //! Buy book
  Future<OrderPaymentEntity> buyBook({required BuyBookParams params});
}
