import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/custom_tab_bar/custom_tab_bar_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/delete_tickets/delete_tickets_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/show_ticktes/show_tickets_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/tickets/show_ticktes/show_tickets_state.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_create_tickets_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/screens_edu/components/edu_tickets/edu_tickets_chat_component.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/tickets/tickets_item_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/tickets_status_switch_case_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../home_edu/presentation_edu/bloc/tickets/delete_tickets/delete_tickets_state.dart';

class EduTicketsSettingsComponent extends StatefulWidget {
  const EduTicketsSettingsComponent({super.key});

  @override
  State<EduTicketsSettingsComponent> createState() =>
      _EduTicketsSettingsComponentState();
}

class _EduTicketsSettingsComponentState
    extends State<EduTicketsSettingsComponent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _statuses = ['open', 'in_progress', 'closed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      _fetchTickets(_statuses[_tabController.index]);
    });

    _fetchTickets(_statuses[_tabController.index]);
  }

  void _fetchTickets(String status) {
    context.read<ShowTicketsBloc>().add(
      ShowTicketsEvent(
        params: ShowTicketsParams(status: status, search: '', page: '1'),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: CustomRefreshIndicator(
        onRefresh: () async {
          _fetchTickets(_statuses[_tabController.index]);
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: SheetDragAreaWg(
                  child: CustomAppBarWg(myTitle: localization.tickets),
                ),
              ),
              SliverPadding(
                padding: AppPadding.horizontal20x(),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CustomTabBarWg(
                        controller: _tabController,
                        firstTab: 'Ochiq',
                        secondTab: 'Jarayonda',
                        thirdTab: 'Yopilgan',
                      ),
                      const SizedBox(height: 20),

                      /// SEARCH BAR
                      AppSearchbarWg(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),

              BlocBuilder<ShowTicketsBloc, ShowTicketsState>(
                builder: (context, state) {
                  if (state is ShowTicketsLoaded) {
                    final data = state.response.data;

                    //! Empty State
                    if (data.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppEmptyState(
                          title: 'Tikketlar bosh!',
                          subtitle:
                              'Birinchi tikketni yaratish va ishni boshlash uchun quyidagi tugmani bosing.',
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            final confirmed =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Ticketni o\'chirish'),
                                    content: const Text(
                                      'Haqiqatan ham bu ticketni o\'chirmoqchimisiz?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Bekor qilish'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text(
                                          'O\'chirish',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ) ??
                                false;

                            if (!confirmed) return false;

                            context.read<DeleteTicketsBloc>().add(
                              DeleteTicketEvent(
                                params: DeleteTicketParams(ticketId: item.id),
                              ),
                            );

                            final result = await context
                                .read<DeleteTicketsBloc>()
                                .stream
                                .firstWhere(
                                  (state) =>
                                      state is DeleteTicketsLoaded ||
                                      state is DeleteTicketsError,
                                );

                            if (result is DeleteTicketsError) {
                              errorFlushBar(
                                context,
                                'O\'chirishda xatolik yuz berdi',
                              );
                              return false;
                            }

                            return true;
                          },
                          onDismissed: (direction) {
                            _fetchTickets(_statuses[_tabController.index]);
                          },
                          child: TicketsItemWg(item: item),
                        );
                      },
                    );
                  }
                  return SliverList.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListTile(
                          onTap: () {},
                          minVerticalPadding: 10,
                          shape: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.greyScale.grey200,
                            ),
                          ),
                          titleAlignment: .top,
                          contentPadding: AppPadding.horizontal20x(),
                          title: Text(
                            'Pullik kurslar bo’yicha ba’tafsil ma’lumot',
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: AppTextStyles.source.medium(fontSize: 15),
                          ),
                          subtitle: Text(
                            'Premium kurslar qanday ishlaydi',
                            style: AppTextStyles.source.regular(
                              fontSize: 12,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                          trailing: ticketsStatusSwitchCase(
                            context,
                            TicketStatus.open,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavContainerWg(
            buttonText: localization.newTicketButton,
            onTap: () {
              FamilyNavigation.familyPush(
                context,
                EduCreateTicketsComponent(),
                showHandle: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
