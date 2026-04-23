import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class AvatarUseCase {
  final HomeRepository repository;

  AvatarUseCase({required this.repository});

  Future<void> call({required AvatarParams params}) {
    return repository.postAvatar(params: params);
  }
}
