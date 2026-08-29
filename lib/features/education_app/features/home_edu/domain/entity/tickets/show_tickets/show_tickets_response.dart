import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/links/links_entity.dart';
import 'package:my_template/features/main_app/home/domain/entity/pagination/meta/meta_entity.dart';

class ShowTicketsResponse {
  final Links links;
  final List<ShowTicketsEntity> data;
  final Meta meta;

  ShowTicketsResponse({
    required this.links,
    required this.data,
    required this.meta,
  });
}
