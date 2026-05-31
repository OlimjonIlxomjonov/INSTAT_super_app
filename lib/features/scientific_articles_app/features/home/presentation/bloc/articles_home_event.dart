/// MAIN EVENT
class ArticlesHomeEvent {
  const ArticlesHomeEvent();
}

/// user articles
class UserArticlesEvent extends ArticlesHomeEvent {
  const UserArticlesEvent();
}

/// review authors
class ReviewAuthorsEvent extends ArticlesHomeEvent {
  final int reviewId;
  const ReviewAuthorsEvent({required this.reviewId});
}

/// review detail
class ReviewDetailEvent extends ArticlesHomeEvent {
  final int reviewId;
  const ReviewDetailEvent({required this.reviewId});
}
