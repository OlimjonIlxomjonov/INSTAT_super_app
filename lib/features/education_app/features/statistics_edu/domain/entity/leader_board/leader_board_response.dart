import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/leader_board/leader_board_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class LeaderBoardResponse {
  final Links? links;
  final List<LeaderBoardEntity> data;
  final Meta? meta;

  LeaderBoardResponse({required this.data, this.meta, this.links});

}
