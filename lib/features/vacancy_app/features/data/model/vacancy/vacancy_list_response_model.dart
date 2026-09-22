import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/vacancy_app/features/data/model/vacancy/vacancy_model.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_list_response.dart';

class VacancyListResponseModel extends VacancyListResponse {
  const VacancyListResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory VacancyListResponseModel.fromJson(Map<String, dynamic> json) {
    return VacancyListResponseModel(
      links: LinksModel.fromJson(json['links'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map((e) => VacancyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaModel.fromJson(json['meta'] ?? {}),
    );
  }
}
