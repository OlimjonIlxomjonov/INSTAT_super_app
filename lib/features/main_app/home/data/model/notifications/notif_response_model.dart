import 'package:my_template/features/main_app/home/data/model/notifications/notif_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_response.dart';

import '../pagination/links/lniks_model.dart';

class NotifResponseModel extends NotifResponse {
  NotifResponseModel({
    required super.links,
    required super.data,
    required super.meta,
  });

  factory NotifResponseModel.fromJson(Map<String, dynamic> json) {
    return NotifResponseModel(
      links: LinksModel.fromJson(json['links']),
      data: (json['data'] as List).map((e) => NotifModel.fromJson(e)).toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
