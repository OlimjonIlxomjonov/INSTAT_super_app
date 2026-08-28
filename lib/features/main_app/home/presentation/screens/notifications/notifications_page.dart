import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications/notif_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/notifications/notif_state.dart';
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
    context.read<NotifBloc>().add(NotifEvent(params: NotifParams()));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<NotifBloc>().add(NotifEvent(params: NotifParams()));
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBarWg(myTitle: localization.notifications),
            //! Body
            BlocBuilder<NotifBloc, NotifState>(
              builder: (context, state) {
                if (state is NotifLoaded) {
                  final data = state.response.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        //! Actual data
                        return NotifItemWg(item: item);
                      },
                    ),
                  );
                }
                //! Loading animation
                return Skeletonizer(
                  enabled: true,
                  child: Container(
                    margin: .symmetric(horizontal: 20),
                    padding: .all(15),
                    decoration: BoxDecoration(
                      borderRadius: .circular(10),
                      border: Border(
                        left: BorderSide(
                          width: 5,
                          color: AppColors.greyScale.grey200,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Statistika (Tarmoqlar va sohalar bo’yicha)',
                          style: AppTextStyles.source.medium(fontSize: 16),
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ushbu topshiriq kurs davomida o‘rganilgan statistik ma’lumotlarni real tarmoqlar va sohalar kesimida tahlil qilishga qaratilgan.',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: AppTextStyles.source.regular(
                            fontSize: 14,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                        Divider(color: AppColors.greyScale.grey200),
                        Row(
                          children: [
                            Spacer(),
                            Icon(
                              FlutterRemix.calendar_line,
                              size: 15,
                              color: AppColors.greyScale.grey400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Bugun  15:00',
                              style: AppTextStyles.source.regular(
                                fontSize: 12,
                                color: AppColors.greyScale.grey400,
                              ),
                            ),
                          ],
                        ),
                      ],
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
