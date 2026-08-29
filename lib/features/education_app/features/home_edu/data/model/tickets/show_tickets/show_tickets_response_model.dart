import 'package:my_template/features/education_app/features/home_edu/data/model/tickets/show_tickets/show_tickets_model.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_response.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';

class ShowTicketsResponseModel extends ShowTicketsResponse {
  ShowTicketsResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory ShowTicketsResponseModel.fromJson(Map<String, dynamic> json) {
    return ShowTicketsResponseModel(
      links: LinksModel.fromJson(json['links']),
      data: (json['data'] as List)
          .map((e) => ShowTicketsModel.fromJson(e))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
