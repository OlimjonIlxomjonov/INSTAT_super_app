import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/layout_buttons/layout_buttons_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/detailed_task_edu_child.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_grid_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/layout_list_calendar_wg.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/widgets_edu/tasks_card_wg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/bloc/course_group_dates_bloc.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/bloc/course_group_dates_event.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/bloc/course_group_dates_state.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/services/layout/layout_prefs_service.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_lessons/offline_lessons_blox.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/offline_lessons/offline_lessons_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/scan_qr/scan_qr_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/scan_qr/scan_qr_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../../core/common/flush_bar/flush_bars.dart';
import '../../../../../table_edu/domain/entity/course_group_date_entity.dart';
import '../../../../../user_courses_edu/presentation_edu/screens_edu/qr_scan/qr_scan_configs.dart';

class DetailedUserGroupComponent extends StatefulWidget {
  final String courseName;
  final int courseGroupId;

  const DetailedUserGroupComponent({
    super.key,
    required this.courseName,
    required this.courseGroupId,
  });

  @override
  State<DetailedUserGroupComponent> createState() =>
      _DetailedUserGroupComponentState();
}

class _DetailedUserGroupComponentState
    extends State<DetailedUserGroupComponent> {
  CourseGroupDateEntity? _selectedCourseDate;
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

  Future<void> _qrScan() async {
    final qr = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScanConfigs()),
    );

    if (!mounted || qr == null) return;

    context.read<ScanQrBloc>().add(
      ScanQrEvent(
        params: ScanQrParams(
          id: _selectedCourseDate!.courseGroup.toString(),
          groupId: _selectedCourseDate!.id.toString(),
          barCode: qr,
        ),
      ),
    );
  }

  Future<void> _loadLayout() async {
    final saved = await LayoutPrefsService.loadCalendarLayout(
      'detailed_user_group_calendar',
    );
    if (mounted) {
      setState(() => layout = saved);
    }
  }

  Future<void> _onLayoutChanged(CalendarLayout newLayout) async {
    setState(() => layout = newLayout);
    await LayoutPrefsService.saveCalendarLayout(
      'detailed_user_group_calendar',
      newLayout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CourseGroupDatesBloc>()
        ..add(
          FetchCourseGroupDatesEvent(
            params: CourseGroupDateParams(courseGroupId: widget.courseGroupId),
          ),
        ),
      child: BlocListener<ScanQrBloc, ScanQrState>(
        listener: (context, state) {
          // if (state is ScanQrLoaded) {
          //   successFlushBar(context, 'Attendance marked successfully.');
          // } else if (state is ScanQrError) {
          //   errorFlushBar(context, 'error');
          // }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverDefaultAppBarWg(
                isFamily: true,
                myTitle: widget.courseName,
                customActions: [
                  LayoutButtonsWg(layout: layout, onChanged: _onLayoutChanged),
                ],
              ),

              SliverToBoxAdapter(
                child: BlocBuilder<CourseGroupDatesBloc, CourseGroupDatesState>(
                  builder: (context, state) {
                    final dates = state is CourseGroupDatesLoaded
                        ? state.dates
                        : <CourseGroupDateEntity>[];

                    return layout == CalendarLayout.month
                        ? SimpleMonthCalendar(
                            dates: dates,
                            onDateSelected: (courseDate) {
                              setState(() {
                                _selectedCourseDate = courseDate;
                              });

                              context.read<OfflineLessonsBloc>().add(
                                OfflineLessonsEvent(
                                  params: OfflineLessonsParams(
                                    id: courseDate.courseGroup.toString(),
                                    groupId: courseDate.id.toString(),
                                  ),
                                ),
                              );
                            },
                          )
                        : SimpleWeekCalendar(
                            dates: dates,
                            onDateSelected: (courseDate) {
                              setState(() {
                                _selectedCourseDate = courseDate;
                              });
                              context.read<OfflineLessonsBloc>().add(
                                OfflineLessonsEvent(
                                  params: OfflineLessonsParams(
                                    id: courseDate.courseGroup.toString(),
                                    groupId: courseDate.id.toString(),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
              BlocBuilder<OfflineLessonsBloc, OfflineLessonsState>(
                builder: (context, state) {
                  if (_selectedCourseDate == null) {
                    return SliverToBoxAdapter(
                      child: AppEmptyState(
                        title: 'Sanani tanlang',
                        subtitle:
                            'Darslarni ko‘rish uchun yuqoridagi kalendardan bir sanani tanlang.',
                      ),
                    );
                  }
                  if (state is OfflineLessonsLoaded) {
                    final data = state.entity;

                    if (data.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppEmptyState(
                          title: 'Darslar hali qo‘shilmagan.',
                          subtitle: 'Boshqa sanani tanlab ko‘ring.',
                        ),
                      );
                    }

                    return SliverFillRemaining(
                      child: Padding(
                        padding: AppPadding.horizontal20x(),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Text(
                                  'Darslar',
                                  style: AppTextStyles.source.semiBold(
                                    fontSize: 17,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _qrScan,
                                  child: const Text("Scan"),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final lessonDate =
                                      _selectedCourseDate?.dateTime ??
                                      DateTime.now();
                                  final item = data[index];
                                  return TasksCardWg(
                                    title: item.title
                                        .replaceAll(RegExp(r'\s+'), ' ')
                                        .trim(),
                                    deadlineDate:
                                        " ${DateFormat('dd MMM • HH:mm').format(lessonDate)}",
                                    onTap: () {
                                      subBottomSheetOpener(
                                        context,
                                        child: DetailedTaskEduChild(),
                                        isExpanded: false,
                                      );
                                    },
                                    isLessons: true,
                                    daysLeft: " ${daysLeft(lessonDate)}",
                                    statusBorderColor:
                                        _selectedCourseDate?.attendanceCount ==
                                            1
                                        ? AppColors.greenDoneTaskCard
                                        : AppColors.redFailedTaskCard,
                                    isTaskDone:
                                        _selectedCourseDate?.attendanceCount ==
                                            1
                                        ? true
                                        : false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: AppPadding.hAndV20x20(),
                      child: Column(
                        children: List.generate(
                          4,
                          (index) => Skeletonizer(
                            enabled: true,
                            child: TasksCardWg(
                              title:
                                  'Statistika (Tarmoqlar va sohalar bo’yicha)',
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
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String daysLeft(DateTime lessonDate) {
    final difference = lessonDate.difference(DateTime.now());

    if (difference.isNegative) {
      return "Completed";
    }

    if (difference.inDays == 0) {
      return "Today";
    }

    if (difference.inDays == 1) {
      return "1 day left";
    }

    return "${difference.inDays} days left";
  }
}
