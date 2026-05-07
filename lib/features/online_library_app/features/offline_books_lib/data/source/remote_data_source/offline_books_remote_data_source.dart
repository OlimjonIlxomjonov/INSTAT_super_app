import 'package:my_template/features/online_library_app/features/offline_books_lib/data/models/offline_books_list_response_model.dart';

abstract class OfflineBooksRemoteDataSource {
  Future<OfflineBooksListResponseModel> fetchOfflineBooks({String search = '', int page = 1});
}
