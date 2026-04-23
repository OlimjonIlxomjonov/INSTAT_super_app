import 'package:my_template/features/education_app/features/statistics_edu/data/models/leader_board/leader_board_model.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_response.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/links/lniks_model.dart';
import 'package:my_template/features/main_app/home/data/model/pagination/meta/meta_model.dart';

class LeaderBoardResponseModel extends LeaderBoardResponse {
  LeaderBoardResponseModel({required super.data, super.links, super.meta});

  factory LeaderBoardResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LeaderBoardResponseModel(data: []);
    }

    return LeaderBoardResponseModel(
      links: json['links'] != null ? LinksModel.fromJson(json['links']) : null,
      data:
          (json['data'] as List?)
              ?.map((e) => LeaderBoardModel.fromJson(e))
              .toList() ??
          [],
      meta: json['meta'] != null ? MetaModel.fromJson(json['meta']) : null,
    );
  }
}
