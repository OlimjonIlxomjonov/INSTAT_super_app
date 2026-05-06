import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/layout_buttons/layout_buttons_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/detailed_task_edu_child.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_grid_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_list_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/tasks_card_wg.dart';

class DetailedUserGroupComponent extends StatefulWidget {
  final String courseName;

  const DetailedUserGroupComponent({super.key, required this.courseName});

  @override
  State<DetailedUserGroupComponent> createState() =>
      _DetailedUserGroupComponentState();
}

class _DetailedUserGroupComponentState
    extends State<DetailedUserGroupComponent> {
  final List<Color> statusIndicatorColor = [
    AppColors.greyNewCard,
    AppColors.redFailedTaskCard,
    AppColors.yellowMidTimeCard,
    AppColors.greenDoneTaskCard,
  ];

  final List statusCircularChekBox = [null, false, null, true];

  CalendarLayout layout = CalendarLayout.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(
            isFamily: true,
            myTitle: widget.courseName,
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

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Darslar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: 16),
                  ...List.generate(
                    4,
                    (index) => TasksCardWg(
                      title: 'Statistika (Tarmoqlar va sohalar bo’yicha)',
                      subTitle: ' User Name',
                      deadlineDate: ' Bugun  15:00',
                      onTap: () {
                        subBottomSheetOpener(
                          context,
                          child: DetailedTaskEduChild(),
                          isExpanded: false,
                        );
                      },
                      isLessons: true,
                      daysLeft: ' 0 kun qoldi',
                      statusBorderColor: statusIndicatorColor[index],
                      isTaskDone: statusCircularChekBox[index],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
