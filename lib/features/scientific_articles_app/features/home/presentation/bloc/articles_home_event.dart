import 'package:my_template/core/common/params/article_params/article_params.dart';

/// MAIN EVENT
class ArticlesHomeEvent {
  const ArticlesHomeEvent();
}

/// user articles
class UserArticlesEvent extends ArticlesHomeEvent {
  final String status;

  const UserArticlesEvent({required this.status});
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

/// articles process
class ArticleProcessEvent extends ArticlesHomeEvent {
  final int articleId;

  ArticleProcessEvent({required this.articleId});
}

class ReviewFilesEvent extends ArticlesHomeEvent {
  final ArticleProcessParams params;

  ReviewFilesEvent({required this.params});
}

/// editions / magazines
class ArticlesEditionsEvent extends ArticlesHomeEvent {
  final ArticleEditionsParams params;

  ArticlesEditionsEvent({required this.params});
}

/// add article
class UdkEvent extends ArticlesHomeEvent {
  final UdkParams params;

  UdkEvent({required this.params});
}

//! drop downs
class ArticleTypeEvent extends ArticlesHomeEvent {}

class JournalSectionsEvent extends ArticlesHomeEvent {}
