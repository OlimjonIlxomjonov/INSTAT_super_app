import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/pagination/load_more_on_scroll.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/core/utils/widgets/search_bar/app_search_field_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/reports/widgets/reports_card_wg.dart';

import '../../bloc/micro_data_event.dart';
import '../../bloc/reports/reports_bloc.dart';
import '../../bloc/reports/reports_state.dart';

class ReportsPage extends StatefulWidget {
  final bool autofocusSearch;

  const ReportsPage({super.key, this.autofocusSearch = false});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _search = '';

  void _fetch() {
    context.read<ReportsBloc>().add(ReportsEvent(search: _search));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return CustomRefreshIndicator(
      onRefresh: () async => _fetch(),
      child: Scaffold(
        // Klaviatura ochilganda oq fon hisobotlarni yopib qo'ymasligi uchun.
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<ReportsBloc, ReportsState>(
          buildWhen: (prev, curr) {
            final p = prev is ReportsLoaded ? prev : null;
            final c = curr is ReportsLoaded ? curr : null;
            return p?.hasMore != c?.hasMore ||
                p?.isLoadingMore != c?.isLoadingMore;
          },
          builder: (context, state) {
            final loaded = state is ReportsLoaded ? state : null;

            return LoadMoreOnScroll(
              canLoadMore:
                  (loaded?.hasMore ?? false) &&
                  !(loaded?.isLoadingMore ?? false),
              onLoadMore: () =>
                  context.read<ReportsBloc>().add(const LoadMoreReportsEvent()),
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  //! app bar
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: SheetDragAreaWg(
                      child: CustomAppBarWg(myTitle: localization.reports),
                    ),
                  ),

                  //! SEARCH BAR
                  SliverAppBar(
                    primary: false,
                    toolbarHeight: 80,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    titleSpacing: 20,
                    title: AppSearchFieldWg(
                      autofocus: widget.autofocusSearch,
                      hintText: localization.searchReportsHint,
                      onChanged: (value) {
                        _search = value;
                        _fetch();
                      },
                    ),
                  ),

                  //! Data
                  const ReportsCardWg(),

                  if (loaded?.isLoadingMore ?? false)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
