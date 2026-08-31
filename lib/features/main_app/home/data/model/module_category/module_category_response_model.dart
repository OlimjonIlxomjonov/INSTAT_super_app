import 'package:my_template/features/main_app/home/data/model/module_category/module_category_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/main_app/home/domain/entity/module_category/module_category_response.dart';

class ModuleCategoryResponseModel extends ModuleCategoryResponse {
  ModuleCategoryResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory ModuleCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return ModuleCategoryResponseModel(
      links: LinksModel.fromJson(json['links']),
      data: (json['data'] as List)
          .map((e) => ModuleCategoryModel.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
