import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/data/model/user_articles/user_articles_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_response.dart';

class UserArticlesResponseModel extends UserArticlesResponse {
  UserArticlesResponseModel({
    required super.links,
    required super.data,
    required super.metaData,
  });

  factory UserArticlesResponseModel.fromJson(Map<String, dynamic> json) {
    return UserArticlesResponseModel(
      links: LinksModel.fromJson(json['links']),
      data:
          (json['data'] as List?)
              ?.map((e) => UserArticlesModel.fromJson(e))
              .toList() ??
          [],
      metaData: MetaModel.fromJson(json['meta']),
    );
  }
}
