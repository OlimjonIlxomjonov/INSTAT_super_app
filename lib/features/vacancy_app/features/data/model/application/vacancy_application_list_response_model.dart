import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/vacancy_app/features/data/model/application/vacancy_application_model.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/application/vacancy_application_list_response.dart';

class VacancyApplicationListResponseModel
    extends VacancyApplicationListResponse {
  const VacancyApplicationListResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory VacancyApplicationListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return VacancyApplicationListResponseModel(
      links: LinksModel.fromJson(json['links'] ?? {}),
      data: (json['data'] as List? ?? [])
          .map(
            (e) => VacancyApplicationModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      meta: MetaModel.fromJson(json['meta'] ?? {}),
    );
  }
}
