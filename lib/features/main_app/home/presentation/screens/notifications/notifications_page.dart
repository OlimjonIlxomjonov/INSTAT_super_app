import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/main_app/home/domain/entity/notifications/notif_enitty.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications/notif_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications/notif_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications_count/notifications_count_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/notifications/notif_itme_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/utils/app_utils.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() {
    context.read<NotifBloc>().add(NotifEvent(params: NotifParams()));
  }

  void _markAllRead() {
    context.read<NotifBloc>().add(MarkAllNotifsReadEvent());
    context.read<NotifCountBloc>().add(NotificationsCountEvent());
  }

  void _openNotification(NotifEntity item) {
    if (!item.isRead) {
      context.read<NotifBloc>().add(MarkNotifReadEvent(id: item.id));
      context.read<NotifCountBloc>().add(NotificationsCountEvent());
    }

    subBottomSheetOpener(
      context,
      isExpanded: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: 120,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatTime(item.createdAt),
                style: AppTextStyles.source.regular(
                  fontSize: 12,
                  color: AppColors.greyScale.grey600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                style: AppTextStyles.source.semiBold(fontSize: 17),
              ),
              const SizedBox(height: 12),
              Text(
                item.message ?? '',
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// KUN KALITI
  DateTime? _dayOf(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  String _dayLabel(AppLocalizations localization, DateTime? day) {
    if (day == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (day == today) return localization.dayStatusToday;
    if (day == today.subtract(const Duration(days: 1))) {
      return localization.dayStatusYesterday;
    }
    return '${day.day.toString().padLeft(2, '0')}.'
        '${day.month.toString().padLeft(2, '0')}.${day.year}';
  }

  String _formatTime(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return '';
    return '${parsed.hour.toString().padLeft(2, '0')}:'
        '${parsed.minute.toString().padLeft(2, '0')}';
  }

  String _itemTimeLabel(AppLocalizations localization, NotifEntity item) {
    final label = _dayLabel(localization, _dayOf(item.createdAt));
    final time = _formatTime(item.createdAt);
    if (label.isEmpty) return time;
    return '$label, $time';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomRefreshIndicator(
      onRefresh: () async => _fetch(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SheetDragAreaWg(
                child: CustomAppBarWg(
                  myTitle: localization.notifications,
                  customActions: [
                    BlocBuilder<NotifBloc, NotifState>(
                      builder: (context, state) {
                        final hasUnread =
                            state is NotifLoaded &&
                            state.response.data.any((e) => !e.isRead);
                        return IconButton(
                          tooltip: localization.markAllAsRead,
                          onPressed: hasUnread ? _markAllRead : null,
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppColors.greyScale.grey200,
                              ),
                            ),
                          ),
                          icon: Icon(
                            FlutterRemix.check_double_line,
                            size: 20,
                            color: hasUnread
                                ? AppColors.greyScale.grey800
                                : AppColors.greyScale.grey400,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            //! Body
            BlocBuilder<NotifBloc, NotifState>(
              builder: (context, state) {
                if (state is NotifError) {
                  return SliverToBoxAdapter(child: ErrorPage());
                }

                if (state is NotifLoaded) {
                  final data = state.response.data;
                  if (data.isEmpty) {
                    return SliverToBoxAdapter(
                      child: AppEmptyState(
                        title: localization.noNotifications,
                        subtitle: localization.noNotificationsSubtitle,
                      ),
                    );
                  }

                  //! Kunlar bo'yicha guruh
                  final grouped = <DateTime?, List<NotifEntity>>{};
                  for (final item in data) {
                    grouped
                        .putIfAbsent(_dayOf(item.createdAt), () => [])
                        .add(item);
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                    sliver: SliverList.list(
                      children: [
                        for (final entry in grouped.entries) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 6),
                            child: Text(
                              _dayLabel(localization, entry.key),
                              style: AppTextStyles.source.medium(
                                fontSize: 14,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ),
                          for (final item in entry.value)
                            NotifItemWg(
                              item: item,
                              timeLabel: _itemTimeLabel(localization, item),
                              onTap: () => _openNotification(item),
                            ),
                        ],
                      ],
                    ),
                  );
                }

                //! Loading
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                  sliver: Skeletonizer.sliver(
                    enabled: true,
                    child: SliverList.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => NotifItemWg(
                        timeLabel: 'Bugun, 10:24',
                        item: NotifEntity(
                          id: 0,
                          title: 'Statistika bo’yicha yangi topshiriq',
                          link: '',
                          message:
                              'Ushbu topshiriq kurs davomida o‘rganilgan '
                              'ma’lumotlarni tahlil qilishga qaratilgan.',
                          isRead: true,
                          createdAt: '',
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
    );
  }
}
