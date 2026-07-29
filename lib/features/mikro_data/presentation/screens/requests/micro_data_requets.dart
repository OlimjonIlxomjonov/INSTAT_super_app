import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/technical_work_flash_bar.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/empty_state_static_text.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';

import '../../../../../core/common/flush_bar/flush_bars.dart';
import '../../../../../core/utils/widgets/edu_categories/edu_categories_wg.dart';

class MicroDataRequests extends StatelessWidget {
  const MicroDataRequests({super.key});

  static const List<Widget> _categories = [
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
    EduCategoriesWg(),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: localization.myRequests, showArrow: true),
      body: CustomScrollView(
        slivers: [
          //! FAKE SEARCH BAR
          SliverAppBar(
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            title: AppSearchbarWg(onTap: () {}),
          ),

          //! CATEGORIES
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(right: 20, top: 24, bottom: 16),
              scrollDirection: Axis.horizontal,
              child: Row(children: _categories),
            ),
          ),

          //! title / REQUESTS
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Text(
                localization.requests,
                style: AppTextStyles.source.semiBold(fontSize: 18),
              ),
            ),
          ),
          SliverPadding(
            padding: const .only(top: 16),
            sliver: SliverToBoxAdapter(
              child: AppEmptyState(
                title: localization.noRequestsTitle,
                subtitle: localization.noRequestsSubtitle,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: localization.submitRequest,
        leadingIcon: Icons.add,
        onTap: () {
          technicalWorkFlushBar(context, localization.comingSoon);
        },
      ),
    );
  }
}
