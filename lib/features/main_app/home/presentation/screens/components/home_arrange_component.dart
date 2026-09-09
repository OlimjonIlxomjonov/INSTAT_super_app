import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_layout/home_layout_cubit.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_layout/home_layout_state.dart';

class HomeArrangeComponent extends StatelessWidget {
  const HomeArrangeComponent({super.key});

  static String sectionTitle(AppLocalizations localization, HomeSectionId id) {
    switch (id) {
      case HomeSectionId.banners:
        return localization.promoBanners;
      case HomeSectionId.activeCourses:
        return localization.studyingCourses;
      case HomeSectionId.popularCourses:
        return localization.popularCourses;
      case HomeSectionId.activeBooks:
        return localization.readingBooks;
      case HomeSectionId.popularBooks:
        return localization.mostPopularBooks;
      case HomeSectionId.userArticles:
        return localization.yourArticles;
      case HomeSectionId.userRequests:
        return localization.myRequests;
      case HomeSectionId.vacancies:
        return localization.jobVacancies;
    }
  }

  static Widget _proxyDecorator(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final value = Curves.easeInOut.transform(animation.value);
        return Material(
          color: Colors.transparent,
          elevation: 6 * value,
          borderRadius: BorderRadius.circular(14),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final cubit = context.read<HomeLayoutCubit>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: SheetDragAreaWg(
              child: CustomAppBarWg(myTitle: localization.arrangeSections),
            ),
          ),

          /// HINT
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                localization.arrangeSectionsSubtitle,
                style: AppTextStyles.source.regular(
                  fontSize: 13,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ),
          ),

          BlocBuilder<HomeLayoutCubit, HomeLayoutState>(
            builder: (context, state) {
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverReorderableList(
                  itemCount: state.order.length,
                  onReorder: cubit.reorder,
                  proxyDecorator: _proxyDecorator,
                  itemBuilder: (context, index) {
                    final id = state.order[index];
                    return _SectionTile(
                      key: ValueKey(id),
                      index: index,
                      title: sectionTitle(localization, id),
                      isVisible: state.isVisible(id),
                      onToggle: () => cubit.toggleVisibility(id),
                    );
                  },
                ),
              );
            },
          ),

          /// RESET
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverToBoxAdapter(
              child: TextButton.icon(
                onPressed: cubit.resetToDefault,
                icon: const Icon(FlutterRemix.refresh_line, size: 18),
                label: Text(localization.resetToDefaultOrder),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.greyScale.grey700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  final int index;
  final String title;
  final bool isVisible;
  final VoidCallback onToggle;

  const _SectionTile({
    super.key,
    required this.index,
    required this.title,
    required this.isVisible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    /// Sudrab ko'chirilayotganda element Overlay'ga chiqadi va Scaffold'dagi
    /// Material'ni yo'qotadi — Switch esa uni talab qiladi. Shuning uchun
    /// fon Container emas, Material bilan chiziladi.
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.greyScale.grey100,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    FlutterRemix.drag_move_2_line,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.source.medium(
                    fontSize: 15,
                    color: isVisible
                        ? AppColors.greyScale.grey900
                        : AppColors.greyScale.grey500,
                  ),
                ),
              ),
              Switch.adaptive(value: isVisible, onChanged: (_) => onToggle()),
            ],
          ),
        ),
      ),
    );
  }
}
