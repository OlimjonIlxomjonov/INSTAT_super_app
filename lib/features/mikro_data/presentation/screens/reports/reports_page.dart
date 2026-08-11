import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/widgets/reports_card_wg.dart';

import '../../../../../core/utils/widgets/edu_categories/edu_categories_wg.dart';
import '../../../../../core/utils/widgets/search_bar/app_serachbar_wg.dart';
import '../../bloc/micro_data_event.dart';
import '../../bloc/reports/reports_bloc.dart';
import 'filter_bottom_sheet_wg.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

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
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<ReportsBloc>().add(ReportsEvent());
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            //! app bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: CustomAppBarWg(myTitle: localization.reports),
              ),
            ),

            //! SEARCH BAR
            SliverAppBar(
              toolbarHeight: 80,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              titleSpacing: 20,
              title: AppSearchbarWg(onTap: () {}),
            ),
            //! Categories
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                child: Row(children: _categories),
              ),
            ),
            //! Data
            const ReportsCardWg(),
          ],
        ),
      ),
    );
  }
}
