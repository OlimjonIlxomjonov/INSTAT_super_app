import 'package:flutter/material.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/layout_buttons/layout_buttons_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_grid_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_list_calendar_wg.dart';

class TableEduPage extends StatefulWidget {
  const TableEduPage({super.key});

  @override
  State<TableEduPage> createState() => _TableEduPageState();
}

class _TableEduPageState extends State<TableEduPage> {
  CalendarLayout layout = CalendarLayout.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(
            myTitle: 'Kalenadar',
            customActions: [
              LayoutButtonsWg(
                layout: layout,
                onChanged: (newLayout) {
                  setState(() {
                    layout = newLayout;
                  });
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: layout == CalendarLayout.month
                ? const SimpleMonthCalendar()
                : const SimpleWeekCalendar(),
          ),
        ],
      ),
    );
  }
}
