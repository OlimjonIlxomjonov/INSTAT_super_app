import 'package:flutter/material.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';

import '../../domain/entity/article_process/article_process_entity.dart';
import '../widgets/last_actions/sliver_last_actions_wg.dart';

class DetailedLastActionsPage extends StatelessWidget {
  final List<ArticleProcessEntity> item;

  const DetailedLastActionsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: 'Ohirgi harakatlar'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          SliverLastActionsWg(items: item),
        ],
      ),
    );
  }
}
