import 'package:my_template/features/main_app/home/data/source/remote_data_source/home_remote_data_source.dart';
import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class HomeRepoImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepoImpl({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  

  @override
  Future<UserEntity> getUserMe() {
    return _remoteDataSource.fetchUserMe();
  }
}
