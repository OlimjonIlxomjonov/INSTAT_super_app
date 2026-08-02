import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';

class BannerModel extends BannerEntity {
  BannerModel({
    required super.id,
    required super.title,
    required super.link,
    required super.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
