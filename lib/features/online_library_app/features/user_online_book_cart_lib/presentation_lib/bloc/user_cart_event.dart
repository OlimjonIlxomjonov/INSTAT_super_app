import 'package:my_template/core/common/params/online_books/online_books_params.dart';

class UserCartMainEvent {
  UserCartMainEvent();
}

class CartEvent extends UserCartMainEvent {}

class RemoveFromCartEvent extends UserCartMainEvent {
  final int bookId;

  RemoveFromCartEvent({required this.bookId});
}

class BuyBookEvent extends UserCartMainEvent {
  final BuyBookParams params;

  BuyBookEvent({required this.params});
}
