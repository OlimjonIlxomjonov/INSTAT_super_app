import 'package:my_template/features/scientific_articles_app/features/home/data/model/article_editions/article_editions_model.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_editions/article_editions_response.dart';

import '../../../../../../main_app/home/data/model/pagination/links/lniks_model.dart';
import '../../../../../../main_app/home/data/model/pagination/meta/meta_model.dart';

class ArticleEditionsResponseModel extends ArticleEditionsResponse {
  ArticleEditionsResponseModel({
    required super.links,
    required super.meta,
    required super.data,
  });

  factory ArticleEditionsResponseModel.fromJson(Map<String, dynamic> json) {
    return ArticleEditionsResponseModel(
      links: LinksModel.fromJson(json['links']),
      meta: MetaModel.fromJson(json['meta']),
      data:
          (json['data'] as List?)
              ?.map((e) => ArticleEditionsModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
