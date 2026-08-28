import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/confirm_dialog/confirm_dialog_wg.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';
import 'package:my_template/features/main_app/home/domain/entity/active_devices/active_devices.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/active_device/active_device_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/active_device/active_devices_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/delete_active_devices/all/delete_all_devices_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/delete_active_devices/all/delete_all_devices_state.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/widgets/active_devices/active_devices_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ActiveDevicesComponent extends StatefulWidget {
  const ActiveDevicesComponent({super.key});

  @override
  State<ActiveDevicesComponent> createState() => _ActiveDevicesComponentState();
}

class _ActiveDevicesComponentState extends State<ActiveDevicesComponent> {
  @override
  void initState() {
    super.initState();
    context.read<ActiveDevicesBloc>().add(ActiveDevicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<ActiveDevicesBloc>().add(ActiveDevicesEvent());
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: SheetDragAreaWg(
                child: CustomAppBarWg(myTitle: 'Aktiv qurilmalar'),
              ),
            ),
            SliverPadding(
              padding: .symmetric(horizontal: 20, vertical: 10),
              sliver: BlocBuilder<ActiveDevicesBloc, ActiveDevicesState>(
                builder: (context, state) {
                  if (state is ActiveDevicesLoaded) {
                    final data = state.listEntity;

                    return SliverList.separated(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return ActiveDevicesWg(item: item);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 0),
                    );
                  }
                  return SliverList.separated(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: true,
                        child: ActiveDevicesWg(
                          item: ActiveDevicesEntity(
                            id: 0,
                            device: 'device',
                            ip: 'ip',
                            location: 'location',
                            browser: 'browser',
                            created: '2026-08-28T17:32:27.511718',
                            lastSeen: '2026-08-28T17:32:27.511718',
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton:
            BlocListener<DeleteAllDevicesBloc, DeleteAllDevicesState>(
              listener: (context, state) {
                if (state is DeleteAllDevicesLoaded) {
                  // await TokenStorageServiceImpl().deleteAccessToken();

                  AppRoute.open(LogInOptionsPage());
                }
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redFailedTaskCard,
                ),
                onPressed: () {
                  showConfirmDialog(
                    context,
                    title: 'Barcha qurilmalardan chiqish',
                    description: 'Rostdan ham akkauntdan chiqmoqchimisiz?',
                    onConfirm: () {
                      context.read<DeleteAllDevicesBloc>().add(
                        DeleteActiveDevicesEvent(),
                      );
                    },
                  );
                },
                child: Icon(FlutterRemix.logout_box_r_line),
              ),
            ),
      ),
    );
  }
}
