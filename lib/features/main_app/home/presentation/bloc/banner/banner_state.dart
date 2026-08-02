import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';

class BannerState {
  const BannerState();
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerEntity> banners;

  const BannerLoaded(this.banners);
}

class BannerError extends BannerState {}
