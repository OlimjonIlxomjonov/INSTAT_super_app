import 'package:my_template/features/mikro_data/data/model/reports/reports_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_response.dart';

import '../../../../main_app/home/data/model/pagination/links/lniks_model.dart';
import '../../../../main_app/home/data/model/pagination/meta/meta_model.dart';

class ReportsResponseModel extends ReportsResponse {
  ReportsResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory ReportsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportsResponseModel(
      links: LinksModel.fromJson(json['links']),
      meta: MetaModel.fromJson(json['meta']),
      data:
          (json['data'] as List?)
              ?.map((e) => ReportsModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
