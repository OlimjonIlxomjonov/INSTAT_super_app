import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/data/sources/remote_data_source/home_lib_remote_data_source.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_page_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_pages_count_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/library_stats/library_stats_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/repository/home_lib_repository.dart';

class HomeLibRepoImpl implements HomeLibRepository {
  final HomeLibRemoteDataSource _remoteDataSource;

  HomeLibRepoImpl({required HomeLibRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<BookListResponse> getPopularBooks({int page = 1}) {
    return _remoteDataSource.fetchPopularBooks(page: page);
  }

  @override
  Future<void> saveDeleteBook(int id) {
    return _remoteDataSource.saveDeleteBook(id);
  }

  @override
  Future<void> addToCart(int id) {
    return _remoteDataSource.addToCart(id);
  }

  @override
  Future<BookListResponse> searchBooks(String search, int page) {
    return _remoteDataSource.searchBooks(search, page);
  }

  @override
  Future<CommentsResponse> bookComments({
    required OnlineBookCommentsParams params,
  }) {
    return _remoteDataSource.fetchBookComments(params: params);
  }

  @override
  Future<void> addComment({required AddCommentParams params}) {
    return _remoteDataSource.addComment(params: params);
  }

  @override
  Future<BookListResponse> getUserBooks({int page = 1}) {
    return _remoteDataSource.fetchUserBooks(page: page);
  }

  @override
  Future<BookListResponse> getSavedBooks({int page = 1}) {
    return _remoteDataSource.fetchSavedBooks(page: page);
  }

  @override
  Future<BookPagesCountEntity> getBookPagesCount(int bookId) {
    return _remoteDataSource.fetchBookPagesCount(bookId);
  }

  @override
  Future<List<BookPageEntity>> getBookPages({required BookPagesParams params}) {
    return _remoteDataSource.fetchBookPages(params: params);
  }

  @override
  Future<void> updateBookCurrentPage({
    required UpdateBookCurrentPageParams params,
  }) {
    return _remoteDataSource.updateBookCurrentPage(params: params);
  }

  @override
  Future<LibraryStatsEntity> getLibraryStats() {
    return _remoteDataSource.fetchLibraryStats();
  }
}
