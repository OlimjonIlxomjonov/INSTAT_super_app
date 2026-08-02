import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../features/mikro_data/domain/entity/data_requests/data_request_entity.dart';
import '../../../../features/mikro_data/presentation/screens/requests/widgets/sliver_data_requests_list_wg.dart';

class DataRequestsSkeletonizer extends StatelessWidget {
  final int itemCount;

  const DataRequestsSkeletonizer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverDataRequestsListWg(
        items: List.generate(
          itemCount,
          (index) => DataRequestEntity(
            id: 0,
            userId: 0,
            fullName: 'Loading request name here',
            status: 'draft',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      ),
    );
  }
}
