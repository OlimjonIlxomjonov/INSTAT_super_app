import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../features/scientific_articles_app/features/home/domain/entity/user_articles/user_articles_entity.dart';
import '../../../../features/scientific_articles_app/features/home/presentation/widgets/sliver_articles_list_wg.dart';

class UserArticlesSkeletonizer extends StatelessWidget {
  const UserArticlesSkeletonizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverArticlesListWg(
        items: List.generate(
          5,
          (index) => UserArticlesEntity(
            id: 0,
            title: 'Loading article title here',
            status: 'draft',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            userId: 001,
          ),
        ),
      ),
    );
  }
}
