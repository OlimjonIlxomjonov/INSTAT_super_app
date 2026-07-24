import 'package:my_template/core/common/params/article_params/article_params.dart';

/// MAIN EVENT
class ArticlesHomeEvent {
  const ArticlesHomeEvent();
}

/// user articles
class UserArticlesEvent extends ArticlesHomeEvent {
  final String status;
  final String search;
  final int page;
  final bool isLoadMore;

  const UserArticlesEvent({
    required this.status,
    required this.search,
    this.page = 1,
    this.isLoadMore = false,
  });
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

class AcademicDegreeEvent extends ArticlesHomeEvent {}

class ResetAddArticleEvent extends ArticlesHomeEvent {}

class UpdateAddArticleFieldEvent extends ArticlesHomeEvent {
  final String? title;
  final int? articleType;
  final String? language;
  final int? journalSection;
  final String? annotationUz;
  final String? annotationRu;
  final String? annotationEn;
  final String? udkCode;
  final List<String>? keywords;

  UpdateAddArticleFieldEvent({
    this.title,
    this.articleType,
    this.language,
    this.journalSection,
    this.annotationUz,
    this.annotationRu,
    this.annotationEn,
    this.udkCode,
    this.keywords,
  });
}

class AddLocalAuthorEvent extends ArticlesHomeEvent {
  final ReviewAuthorParams author;

  AddLocalAuthorEvent({required this.author});
}

class RemoveLocalAuthorEvent extends ArticlesHomeEvent {
  final int index;

  RemoveLocalAuthorEvent({required this.index});
}

class SaveArticleDraftEvent extends ArticlesHomeEvent {
  final Function()? onSuccess;
  final Function(String)? onError;

  SaveArticleDraftEvent({this.onSuccess, this.onError});
}

/// Submitting for review is a payment action on the backend (create-order),
/// not a plain status update — this is what actually transitions the review
/// out of draft and creates its process log entry.
class SubmitArticleForReviewEvent extends ArticlesHomeEvent {
  final String paymentMethod;
  final Function()? onSuccess;
  final Function(String)? onError;

  SubmitArticleForReviewEvent({
    required this.paymentMethod,
    this.onSuccess,
    this.onError,
  });
}

class CreateReviewAuthorEvent extends ArticlesHomeEvent {
  final ReviewAuthorParams author;
  final Function()? onSuccess;
  final Function(String)? onError;

  CreateReviewAuthorEvent({required this.author, this.onSuccess, this.onError});
}

class MainFileArticleEvent extends ArticlesHomeEvent {
  final AddMainFileParams params;

  MainFileArticleEvent({required this.params});
}

class AntiplagiatFileEvent extends ArticlesHomeEvent {
  final AddAntiplagiatFileParams params;

  AntiplagiatFileEvent({required this.params});
}

class UploadReviewFileEvent extends ArticlesHomeEvent {
  final AddReviewFileParams params;

  UploadReviewFileEvent({required this.params});
}

class LoadArticleForEditEvent extends ArticlesHomeEvent {
  final int reviewId;

  LoadArticleForEditEvent({required this.reviewId});
}

class UpdateArticleUploadedFileEvent extends ArticlesHomeEvent {
  final String? mainFileName;
  final int? mainFileSize;
  final String? antiplagiatFileName;
  final int? antiplagiatFileSize;

  const UpdateArticleUploadedFileEvent({
    this.mainFileName,
    this.mainFileSize,
    this.antiplagiatFileName,
    this.antiplagiatFileSize,
  });
}

class RefreshArticleFilesEvent extends ArticlesHomeEvent {
  const RefreshArticleFilesEvent();
}

class UpdateReviewAuthorEvent extends ArticlesHomeEvent {
  final ReviewAuthorParams author;
  final Function()? onSuccess;
  final Function(String)? onError;

  UpdateReviewAuthorEvent({required this.author, this.onSuccess, this.onError});
}
