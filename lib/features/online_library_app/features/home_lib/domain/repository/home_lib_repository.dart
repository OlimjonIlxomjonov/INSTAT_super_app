import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_page_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_pages_count_entity.dart';

abstract class HomeLibRepository {
  Future<BookListResponse> getPopularBooks({int page = 1});

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
  Future<BookListResponse> getUserBooks({int page = 1});

  //! user saved (liked) books
  Future<BookListResponse> getSavedBooks({int page = 1});

  //! online book reader
  Future<BookPagesCountEntity> getBookPagesCount(int bookId);

  Future<List<BookPageEntity>> getBookPages({required BookPagesParams params});

  Future<void> updateBookCurrentPage({
    required UpdateBookCurrentPageParams params,
  });
}
