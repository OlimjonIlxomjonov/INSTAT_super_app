import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/home_edu/data/model/comments/comments_response_model.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/models/book/book_list_response_model.dart';

abstract class HomeLibRemoteDataSource {
  Future<BookListResponseModel> fetchPopularBooks();

  Future<void> saveDeleteBook(int id);

  Future<void> addToCart(int id);

  Future<BookListResponseModel> searchBooks(String search, int page);

  //! Book comments
  Future<CommentsResponseModel> fetchBookComments({
    required OnlineBookCommentsParams params,
  });

  //! Add Comment
  Future<void> addComment({required AddCommentParams params});

  //! user books
  Future<BookListResponseModel> fetchUserBooks();
}
