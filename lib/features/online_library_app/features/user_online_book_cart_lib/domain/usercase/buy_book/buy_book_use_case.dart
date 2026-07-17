import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/order_payment/order_payment_entity.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/repository/user_online_book_cart_repository.dart';

class BuyBookUseCase {
  final UserOnlineBookCartRepository repository;

  BuyBookUseCase({required this.repository});

  Future<OrderPaymentEntity> call({required BuyBookParams params}) {
    return repository.buyBook(params: params);
  }
}
