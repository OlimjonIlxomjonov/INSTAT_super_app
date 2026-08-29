import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';

import '../bloc/review_process/review_process_bloc.dart';
import '../bloc/review_process/review_process_state.dart';
import '../widgets/last_actions/sliver_last_actions_wg.dart';

class DetailedLastActionsPage extends StatelessWidget {
  const DetailedLastActionsPage({super.key});

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
          BlocBuilder<ReviewProcessBloc, ReviewProcessState>(
            builder: (context, state) {
              if (state is ReviewProcessLoaded) {
                if (state.listEntity.isEmpty) {
                  return SliverToBoxAdapter(
                    child: AppEmptyState(
                      title: 'Navbat bo‘sh',
                      subtitle:
                          'Jarayonni boshlash uchun birinchi arizangizni yuboring.',
                    ),
                  );
                }
                return SliverLastActionsWg(items: state.listEntity);
              }
              return SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
