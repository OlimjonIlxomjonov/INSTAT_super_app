class OnlineBookCommentsParams {
  final int bookId;

  OnlineBookCommentsParams({required this.bookId});
}

class BuyBookParams {
  final List<int> bookId;
  final String paymentMethod;

  BuyBookParams({required this.bookId, required this.paymentMethod});
}

class AddCommentParams {
  final int bookId, stars;
  final String bookDesc;

  AddCommentParams({
    required this.bookId,
    required this.stars,
    required this.bookDesc,
  });
}
