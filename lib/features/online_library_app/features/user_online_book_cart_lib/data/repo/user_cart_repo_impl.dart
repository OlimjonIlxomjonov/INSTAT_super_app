import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_list_response.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/data/source/remote_data_source/cart_remote_data_srouce.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/domain/repository/user_online_book_cart_repository.dart';

class UserCartRepoImpl implements UserOnlineBookCartRepository {
  final CartRemoteDataSource _remoteDataSource;

  UserCartRepoImpl({required CartRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<BookListResponse> getCart() {
    return _remoteDataSource.fetchCart();
  }
}
