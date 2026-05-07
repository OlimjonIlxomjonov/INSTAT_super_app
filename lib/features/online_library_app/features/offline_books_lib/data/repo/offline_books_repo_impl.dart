import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/data/source/remote_data_source/offline_books_remote_data_source.dart';
import 'package:my_template/features/online_library_app/features/offline_books_lib/domain/repository/offline_books_repository.dart';

class OfflineBooksRepoImpl implements OfflineBooksRepository {
  final OfflineBooksRemoteDataSource _remoteDataSource;

  OfflineBooksRepoImpl({required OfflineBooksRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<BookListResponse> fetchOfflineBooks({String search = '', int page = 1}) {
    return _remoteDataSource.fetchOfflineBooks(search: search, page: page);
  }
}
