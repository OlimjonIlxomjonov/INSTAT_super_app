import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/services/token_storage/jwt_utils.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_group_members/course_group_members_use_case.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/layout_buttons/layout_buttons_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
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

import '../../../../../table_edu/domain/entity/course_group_date_entity.dart';
import '../../../../../user_courses_edu/domain/entity/offline_course/offline_course_teacher_entity.dart';
import '../../../../../user_courses_edu/presentation_edu/screens_edu/qr_scan/qr_scan_configs.dart';

class DetailedUserGroupComponent extends StatefulWidget {
  final String courseName;
  final int courseGroupId;
  final List<OfflineCourseTeacherEntity> teacherName;

  const DetailedUserGroupComponent({
    super.key,
    required this.courseName,
    required this.courseGroupId,
    required this.teacherName,
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

  //! Shu sanadagi shaxsiy davomat; null — yuklanmoqda
  bool? _attended;

  late final int? _myUserId = () {
    final token = TokenStorageServiceImpl().getAccessToken();
    return token == null ? null : jwtUserId(token);
  }();

  @override
  void initState() {
    super.initState();
    _loadLayout();
  }

  void _selectDate(BuildContext context, CourseGroupDateEntity courseDate) {
    setState(() {
      _selectedCourseDate = courseDate;
      _attended = null;
    });
    context.read<OfflineLessonsBloc>().add(
      OfflineLessonsEvent(
        params: OfflineLessonsParams(
          id: courseDate.courseGroup.toString(),
          groupId: courseDate.id.toString(),
        ),
      ),
    );
    _loadAttendance(courseDate);
  }

  Future<void> _loadAttendance(CourseGroupDateEntity courseDate) async {
    try {
      final members = await sl<CourseGroupDateMembersUseCase>()(
        params: OfflineLessonsParams(
          id: courseDate.courseGroup.toString(),
          groupId: courseDate.id.toString(),
        ),
      );
      if (!mounted || _selectedCourseDate?.id != courseDate.id) return;
      final me = members.where((m) => m.userId == _myUserId).firstOrNull;
      setState(() => _attended = (me?.attendanceCount ?? 0) > 0);
    } catch (_) {
      if (mounted && _selectedCourseDate?.id == courseDate.id) {
        setState(() => _attended = false);
      }
    }
  }

  //! Ochilganda bugungi dars
  void _selectTodayIfAny(
    BuildContext context,
    List<CourseGroupDateEntity> dates,
  ) {
    if (_selectedCourseDate != null) return;
    final now = DateTime.now();
    final today = dates
        .where(
          (d) =>
              d.dateTime.year == now.year &&
              d.dateTime.month == now.month &&
              d.dateTime.day == now.day,
        )
        .firstOrNull;
    if (today != null) _selectDate(context, today);
  }

  Future<void> _refresh(BuildContext context) async {
    final datesBloc = context.read<CourseGroupDatesBloc>();
    datesBloc.add(
      FetchCourseGroupDatesEvent(
        params: CourseGroupDateParams(courseGroupId: widget.courseGroupId),
      ),
    );
    final selected = _selectedCourseDate;
    if (selected != null) _selectDate(context, selected);
    await datesBloc.stream.firstWhere((s) => s is! CourseGroupDatesLoading);
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

  //! Davomatdan keyin
  void _reloadAfterScan(BuildContext context) {
    final courseDate = _selectedCourseDate;
    if (courseDate == null) return;

    context.read<CourseGroupDatesBloc>().add(
      FetchCourseGroupDatesEvent(
        params: CourseGroupDateParams(courseGroupId: widget.courseGroupId),
      ),
    );
    _selectDate(context, courseDate);
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
    final localization = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<CourseGroupDatesBloc>()
        ..add(
          FetchCourseGroupDatesEvent(
            params: CourseGroupDateParams(courseGroupId: widget.courseGroupId),
          ),
        ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<ScanQrBloc, ScanQrState>(
            listener: (context, state) {
              if (state is ScanQrLoaded) {
                successFlushBar(context, localization.attendanceMarked);
                _reloadAfterScan(context);
              } else if (state is ScanQrError) {
                errorFlushBar(
                  context,
                  state.message ?? localization.attendanceFailed,
                );
              }
            },
          ),
          BlocListener<CourseGroupDatesBloc, CourseGroupDatesState>(
            listener: (context, state) {
              if (state is CourseGroupDatesLoaded) {
                _selectTodayIfAny(context, state.dates);
              }
            },
          ),
        ],
        child: Scaffold(
          body: Builder(
            builder: (context) => CustomRefreshIndicator(
              onRefresh: () => _refresh(context),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    title: SheetDragAreaWg(
                      child: CustomAppBarWg(
                        myTitle: widget.courseName,
                        customActions: [
                          LayoutButtonsWg(
                            layout: layout,
                            onChanged: _onLayoutChanged,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child:
                        BlocBuilder<
                          CourseGroupDatesBloc,
                          CourseGroupDatesState
                        >(
                          builder: (context, state) {
                            final dates = state is CourseGroupDatesLoaded
                                ? state.dates
                                : <CourseGroupDateEntity>[];

                            return layout == CalendarLayout.month
                                ? SimpleMonthCalendar(
                                    dates: dates,
                                    onDateSelected: (courseDate) =>
                                        _selectDate(context, courseDate),
                                  )
                                : SimpleWeekCalendar(
                                    dates: dates,
                                    onDateSelected: (courseDate) =>
                                        _selectDate(context, courseDate),
                                  );
                          },
                        ),
                  ),
                  BlocBuilder<OfflineLessonsBloc, OfflineLessonsState>(
                    builder: (context, state) {
                      if (_selectedCourseDate == null) {
                        return SliverToBoxAdapter(
                          child: AppEmptyState(
                            title: localization.selectDateEmptyTitle,
                            subtitle: localization.selectDateEmptySubtitle,
                          ),
                        );
                      }
                      if (state is OfflineLessonsLoaded) {
                        final data = state.entity;

                        if (data.isEmpty) {
                          return SliverToBoxAdapter(
                            child: AppEmptyState(
                              title: localization.noLessonsAddedYetTitle,
                              subtitle: localization.tryAnotherDateSubtitle,
                            ),
                          );
                        }

                        return SliverFillRemaining(
                          child: Padding(
                            padding: const .symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                //! Title / Attendance scan
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      localization.lessonsTitle,
                                      style: AppTextStyles.source.semiBold(
                                        fontSize: 17,
                                      ),
                                    ),
                                    FilledButton.icon(
                                      onPressed: _qrScan,
                                      icon: const Icon(
                                        Icons.qr_code_scanner,
                                        size: 20,
                                      ),
                                      label: Text(localization.scanButton),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
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
                                        teachers: widget.teacherName,
                                        title: item.title
                                            .replaceAll(RegExp(r'\s+'), ' ')
                                            .trim(),
                                        deadlineDate:
                                            " ${DateFormat('dd MMM • HH:mm').format(lessonDate)}",
                                        onTap: () {},
                                        isLessons: true,
                                        daysLeft:
                                            " ${daysLeft(context, lessonDate)}",
                                        statusBorderColor: _statusColor(
                                          lessonDate,
                                        ),
                                        isTaskDone: _statusDone(lessonDate),
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
                                  statusBorderColor:
                                      statusIndicatorColor[index],
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
        ),
      ),
    );
  }

  //! Kelmagan dars — neytral, o'tgan — qatnashgan/qatnashmagan
  bool? _statusDone(DateTime lessonDate) {
    if (_attended == true) return true;
    if (_attended == null || lessonDate.isAfter(DateTime.now())) return null;
    return false;
  }

  Color _statusColor(DateTime lessonDate) => switch (_statusDone(lessonDate)) {
    true => AppColors.greenDoneTaskCard,
    false => AppColors.redFailedTaskCard,
    null => AppColors.greyNewCard,
  };

  String daysLeft(BuildContext context, DateTime lessonDate) {
    final localization = AppLocalizations.of(context)!;
    final difference = lessonDate.difference(DateTime.now());

    if (difference.isNegative) {
      return localization.dayStatusCompleted;
    }

    if (difference.inDays == 0) {
      return localization.dayStatusToday;
    }

    if (difference.inDays == 1) {
      return localization.dayStatusOneDayLeft;
    }

    return localization.dayStatusDaysLeft(difference.inDays);
  }
}
