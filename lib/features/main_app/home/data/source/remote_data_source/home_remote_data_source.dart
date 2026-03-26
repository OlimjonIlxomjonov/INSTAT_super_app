import 'package:my_template/features/main_app/home/data/model/user_me/user_model.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> fetchUserMe();
}