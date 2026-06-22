class UserCartMainEvent {
  UserCartMainEvent();
}

class CartEvent extends UserCartMainEvent {}

class RemoveFromCartEvent extends UserCartMainEvent {
  final int bookId;
  RemoveFromCartEvent({required this.bookId});
}
