class OnlineBookCommentsParams {
  final int bookId;

  OnlineBookCommentsParams({required this.bookId});
}

class BuyBookParams {
  final List<int> bookId;
  final String paymentMethod;

  BuyBookParams({required this.bookId, required this.paymentMethod});
}
