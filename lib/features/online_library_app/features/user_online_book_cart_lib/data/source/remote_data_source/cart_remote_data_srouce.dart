import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/data/models/order_payment/order_payment_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';

abstract class CartRemoteDataSource {
  Future<BookListResponseModel> fetchCart();

  Future<OrderPaymentModel> buyBooks({required BuyBookParams params});
}
