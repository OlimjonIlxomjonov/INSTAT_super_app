import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/requests/requests_card_wg.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverAppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: 'Mening arizalarim'),
            ),
          ),

          //! Search bar
          SliverAppBar(
            toolbarHeight: 80,
            pinned: true,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: AppSearchbarWg(onTap: () => {}),
          ),

          //! Title
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Arizalar',
                style: AppTextStyles.source.semiBold(fontSize: 18),
              ),
            ),
          ),

          //! Requests
          SliverList.separated(
            itemCount: 2,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, _) => const RequestsCardWg(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
