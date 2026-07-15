import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/services/layout/layout_prefs_service.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/layout_buttons/layout_buttons_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/detailed_task_edu_child.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_grid_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_list_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/tasks_card_wg.dart';

class TableEduPage extends StatefulWidget {
  const TableEduPage({super.key});

  @override
  State<TableEduPage> createState() => _TableEduPageState();
}

class _TableEduPageState extends State<TableEduPage> {
  final List<Color> statusIndicatorColor = [
    AppColors.greyNewCard,
    AppColors.redFailedTaskCard,
    AppColors.yellowMidTimeCard,
    AppColors.greenDoneTaskCard,
  ];

  final List statusCircularChekBox = [null, false, null, true];
  CalendarLayout layout = CalendarLayout.month;

  @override
  void initState() {
    super.initState();
    _loadLayout();
  }

  Future<void> _loadLayout() async {
    final saved = await LayoutPrefsService.loadCalendarLayout(
      'table_edu_calendar',
    );
    if (mounted) {
      setState(() => layout = saved);
    }
  }

  Future<void> _onLayoutChanged(CalendarLayout newLayout) async {
    setState(() => layout = newLayout);
    await LayoutPrefsService.saveCalendarLayout(
      'table_edu_calendar',
      newLayout,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(
        myTitle: localization.calendarTitle,
        showArrow: false,
        customActions: [
          LayoutButtonsWg(layout: layout, onChanged: _onLayoutChanged),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: layout == CalendarLayout.month
                ? const SimpleMonthCalendar(dates: [])
                : const SimpleWeekCalendar(dates: []),
          ),

          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(height: appH(16)),
                  Text(
                    localization.tasksTitle,
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  ...List.generate(
                    4,
                    (index) => TasksCardWg(
                      title: 'Statistika (Tarmoqlar va sohalar bo’yicha)',
                      subTitle:
                          'Ushbu topshiriq kurs davomida o‘rganilgan statistik ma’lumotlarni real tarmoqlar va sohalar kesimida tahlil qilishga qaratilgan.',
                      deadlineDate: ' Bugun  15:00',
                      onTap: () {
                        subBottomSheetOpener(
                          context,
                          child: DetailedTaskEduChild(),
                          isExpanded: false,
                        );
                      },
                      daysLeft: ' 0 kun qoldi',
                      statusBorderColor: statusIndicatorColor[index],
                      isTaskDone: statusCircularChekBox[index],
                    ),
                  ),
                  SizedBox(height: appH(20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
