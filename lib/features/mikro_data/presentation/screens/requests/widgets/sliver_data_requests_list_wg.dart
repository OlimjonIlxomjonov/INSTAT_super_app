import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/data_request_card_wg.dart';

class SliverDataRequestsListWg extends StatelessWidget {
  final List<DataRequestEntity> items;

  /// Qoralama tahrirlanib yopilgach ro'yxatni yangilash uchun.
  final VoidCallback? onRequestUpdated;

  const SliverDataRequestsListWg({
    super.key,
    required this.items,
    this.onRequestUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) =>
            DataRequestCardWg(item: items[index], onUpdated: onRequestUpdated),
      ),
    );
  }
}
