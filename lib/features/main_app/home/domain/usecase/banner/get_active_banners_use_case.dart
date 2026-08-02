import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';
import 'package:my_template/features/main_app/home/domain/repository/home_repository.dart';

class GetActiveBannersUseCase {
  final HomeRepository repository;

  GetActiveBannersUseCase({required this.repository});

  Future<List<BannerEntity>> call() {
    return repository.getActiveBanners();
  }
}
