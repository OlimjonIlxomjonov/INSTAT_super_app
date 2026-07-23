import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';

abstract class HomeLibRepository {
  Future<BookListResponse> getPopularBooks();

  Future<void> saveDeleteBook(int id);

  Future<void> addToCart(int id);

  Future<BookListResponse> searchBooks(String search, int page);

  //! Online Book comments
  Future<CommentsResponse> bookComments({
    required OnlineBookCommentsParams params,
  });

  //! Add a Comment
  Future<void> addComment({required AddCommentParams params});

  //! user bought books
  Future<BookListResponse> getUserBooks();
}
