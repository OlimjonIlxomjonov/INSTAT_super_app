import 'package:my_template/features/main_app/home/domain/entity/user_me/user_entity.dart';

abstract class HomeRepository {
  Future<UserEntity> getUserMe();
}
