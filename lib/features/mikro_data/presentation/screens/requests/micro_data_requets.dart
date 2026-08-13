import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/data_requests/data_requests_skeletonizer.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/edu_categories/edu_categories_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/add_data_request_page.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_requests/data_requests_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_requests/data_requests_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/data_request_filters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/sliver_data_requests_list_wg.dart';

class MicroDataRequests extends StatelessWidget {
  const MicroDataRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataRequestsBloc>(
      create: (_) => sl<DataRequestsBloc>(),
      child: const _MicroDataRequestsView(),
    );
  }
}

class _MicroDataRequestsView extends StatefulWidget {
  const _MicroDataRequestsView();

  @override
  State<_MicroDataRequestsView> createState() => _MicroDataRequestsViewState();
}

class _MicroDataRequestsViewState extends State<_MicroDataRequestsView> {
  late final DataRequestsBloc _bloc;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  int _selectedIndex = 0;
  List<DataRequestFilter> _filters = const [];

  @override
  void initState() {
    super.initState();
    _bloc = context.read<DataRequestsBloc>();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Filtr yorliqlari lokalizatsiyaga bog'liq, shuning uchun shu yerda.
    final wasEmpty = _filters.isEmpty;
    _filters = dataRequestFilters(AppLocalizations.of(context)!);
    if (wasEmpty) _fetch();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  String get _currentStatus => _filters[_selectedIndex].apiValue;

  void _fetch({String? search}) {
    _bloc.add(
      DataRequestsEvent(
        status: _currentStatus,
        search: search ?? _searchController.text,
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetch(search: query);
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll < maxScroll - 200) return;

    final state = _bloc.state;
    if (state is! DataRequestsLoaded || !state.canLoadMore) return;

    _bloc.add(
      DataRequestsEvent(
        status: state.status,
        search: state.search,
        page: state.response.metaData.currentPage + 1,
        isLoadMore: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomRefreshIndicator(
        onRefresh: () async => _fetch(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            //! HEADER
            // SliverToBoxAdapter(
            //   child: SheetDragAreaWg(
            //     child: CustomAppBarWg(
            //       myTitle: localization.myRequests,
            //       showArrow: true,
            //     ),
            //   ),
            // ),

            //! SEARCH BAR
            SliverAppBar(
              toolbarHeight: 80,
              pinned: true,
              automaticallyImplyLeading: false,
              title: SheetDragAreaWg(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.greyScale.grey200,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconlyLight.search,
                        color: AppColors.greyScale.grey600,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: AppTextStyles.source.regular(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: localization.searchRequestsHint,
                            hintStyle: AppTextStyles.source.regular(
                              fontSize: 14,
                              color: AppColors.greyScale.grey500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //! STATUS FILTERS
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(right: 20, top: 10),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    return EduCategoriesWg(
                      categoryName: _filters[index].label,
                      categoryIcon: _filters[index].icon,
                      isSelected: _selectedIndex == index,
                      onTap: () {
                        if (_selectedIndex == index) return;
                        setState(() => _selectedIndex = index);
                        _searchController.clear();
                        _debounce?.cancel();
                        _fetch(search: '');
                      },
                    );
                  }),
                ),
              ),
            ),

            //! TITLE
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: SliverToBoxAdapter(
                child: Text(localization.requests, style: CustomTextStyles.h2),
              ),
            ),

            //! REQUESTS
            BlocBuilder<DataRequestsBloc, DataRequestsState>(
              builder: (context, state) {
                if (state is DataRequestsLoaded) {
                  final data = state.response.data;
                  if (data.isEmpty) {
                    return SliverToBoxAdapter(
                      child: AppEmptyState(
                        title: localization.noRequestsTitle,
                        subtitle: localization.noRequestsSubtitle,
                      ),
                    );
                  }
                  return SliverMainAxisGroup(
                    slivers: [
                      SliverDataRequestsListWg(
                        items: data,
                        onRequestUpdated: _fetch,
                      ),
                      if (state.isLoadingMore)
                        const DataRequestsSkeletonizer(itemCount: 2),
                    ],
                  );
                } else if (state is DataRequestsError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            ErrorPage(),
                            Text(
                              localization.somethingWentWrongTitle,
                              style: CustomTextStyles.h3half,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              localization.checkConnectionAndRetry,
                              style: CustomTextStyles.h4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const DataRequestsSkeletonizer();
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
      bottomNavigationBar: keyboardVisible
          ? null
          : CustomBottomNavContainerWg(
              buttonText: localization.submitRequest,
              leadingIcon: Icons.add,
              onTap: () async {
                await openMiniAppSheetFamily(
                  context,
                  child: const AddDataRequestPage(),
                  enableDrag: false,
                  showHandler: false,
                );
                if (!mounted) return;
                _fetch();
              },
            ),
    );
  }
}
