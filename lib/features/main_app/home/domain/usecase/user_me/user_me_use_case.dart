import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class UserMeUseCase {
  final HomeRepository repository;

  UserMeUseCase({required this.repository});

  Future<UserEntity> call() {
    return repository.getUserMe();
  }
}
