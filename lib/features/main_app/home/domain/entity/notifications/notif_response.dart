import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_enitty.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class NotifResponse {
  final Links links;
  final List<NotifEntity> data;
  final Meta meta;

  NotifResponse({required this.links, required this.data, required this.meta});
}
