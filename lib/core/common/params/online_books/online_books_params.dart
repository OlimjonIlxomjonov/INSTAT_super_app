class OnlineBookCommentsParams {
  final int bookId;

  OnlineBookCommentsParams({required this.bookId});
}

class BuyBookParams {
  final List<int> bookId;
  final String paymentMethod;

  BuyBookParams({required this.bookId, required this.paymentMethod});
}

class BookPagesParams {
  final int bookId;
  final int pageNumber;

  BookPagesParams({required this.bookId, required this.pageNumber});
}

class UpdateBookCurrentPageParams {
  final int bookId;
  final int currentPage;

  UpdateBookCurrentPageParams({
    required this.bookId,
    required this.currentPage,
  });
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
