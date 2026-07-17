import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/short_book_details_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_state.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/user_cart_event.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/widget/buy_book_options.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/common/flush_bar/flush_bars.dart';
import '../../../../../../core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import '../../../home_lib/presentation/screens/lib_components/see_all_online_books_component.dart';

class UserOnlineBookCartLibPage extends StatefulWidget {
  const UserOnlineBookCartLibPage({super.key});

  @override
  State<UserOnlineBookCartLibPage> createState() =>
      _UserOnlineBookCartLibPageState();
}

class _UserOnlineBookCartLibPageState extends State<UserOnlineBookCartLibPage> {
  final Set<int> _selectedBookIds = {};
  bool _selectionInitialized = false;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartEvent());
  }

  void _toggleSelected(int bookId) {
    setState(() {
      if (!_selectedBookIds.remove(bookId)) {
        _selectedBookIds.add(bookId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final cartState = context.watch<CartBloc>().state;
    final isLoading = cartState is CartLoading;
    final items = cartState is CartLoaded ? cartState.response.data : null;
    final itemCount = items?.length ?? 5;
    final isEmpty = cartState is CartLoaded && cartState.response.data.isEmpty;

    /// Selection only matters once there's more than one book in the cart —
    /// with a single book it's always the one being bought.
    final isMultiSelect = (items?.length ?? 0) > 1;

    if (items != null) {
      final currentIds = items.map((item) => item.id).toSet();
      if (!_selectionInitialized) {
        // Default to everything selected the first time the cart loads.
        _selectedBookIds.addAll(currentIds);
        _selectionInitialized = true;
      } else {
        _selectedBookIds.retainWhere(currentIds.contains);
      }
    }

    final List<BookEntity> selectedItems = items == null
        ? const <BookEntity>[]
        : isMultiSelect
        ? items.where((item) => _selectedBookIds.contains(item.id)).toList()
        : items;
    final selectedIds = selectedItems.map((item) => item.id).toList();
    final totalPrice = selectedItems.fold<num>(
      0,
      (sum, item) => sum + item.price,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: localization.cart),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Skeletonizer(
                    enabled: isLoading,
                    child: Column(
                      children: List.generate(itemCount, (index) {
                        final item = items?[index];
                        final thumbnail =
                            item != null && item.bookThumbnails.isNotEmpty
                            ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${item.bookThumbnails.first.file}'
                            : '';
                        return Stack(
                          children: [
                            ShortBookDetailsWg(
                              imagePath: thumbnail,
                              bookName: item?.name ?? 'Placeholder Book Title',
                              bookAuthor: item?.author.name ?? 'Author Name',
                              newPrice: item != null
                                  ? '${item.price} UZS'
                                  : '000 000 UZS',
                            ),
                            if (item != null && isMultiSelect)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _toggleSelected(item.id),
                                  child: SizedBox(
                                    width: 150,
                                    height: 180,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: _SelectIndicator(
                                          isSelected: _selectedBookIds.contains(
                                            item.id,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (item != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      context.read<CartBloc>().add(
                                        RemoveFromCartEvent(bookId: item.id),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.greyScale.grey50,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.greyScale.grey200,
                                        ),
                                      ),
                                      child: Icon(
                                        IconlyLight.delete,
                                        size: 20,
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                  if (isEmpty)
                    AppEmptyState(
                      title: localization.cartEmpty,
                      subtitle: localization.cartEmptySubtitle,
                      buttonLabel: localization.continueButton,
                      onAction: () {
                        // openMiniAppSheetFamily(
                        //   context,
                        //   showHandler: false,
                        //   child: SeeAllOnlineBooksComponent(),
                        // );
                        FamilyNavigation.familyPush(
                          showHandle: false,
                          context,
                          SeeAllOnlineBooksComponent(),
                        );
                      },
                    ),
                  SizedBox(height: appH(30)),
                  if (!isEmpty)
                    _buildSimpleRow(
                      localization.totalItems,
                      localization.countSuffix(itemCount),
                    ),
                  SizedBox(height: 12),
                  if (!isEmpty) Divider(color: AppColors.greyScale.grey200),
                  SizedBox(height: 16),
                  if (!isEmpty)
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          localization.totalAmount,
                          style: AppTextStyles.source.medium(fontSize: 17),
                        ),
                        Text(
                          '$totalPrice UZS',
                          style: AppTextStyles.source.medium(fontSize: 17),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isEmpty
          ? CustomBottomNavContainerWg(
              buttonText: localization.buyForPrice(totalPrice),
              onTap: () {
                if (selectedIds.isEmpty) {
                  errorFlushBar(
                    context,
                    localization.selectAtLeastOneBookMessage,
                  );
                  return;
                }
                onlineLibStyleCustomBottomSheetWg(
                  context,
                  headerTitle: localization.paymentTypeTitle,
                  child: BuyBookOptions(bookIds: selectedIds),
                );
              },
            )
          : null,
    );
  }

  Row _buildSimpleRow(String title, trailText) => Row(
    mainAxisAlignment: .spaceBetween,
    children: [
      Text(title, style: AppTextStyles.source.regular(fontSize: 15)),
      Text(trailText, style: AppTextStyles.source.regular(fontSize: 15)),
    ],
  );
}

class _SelectIndicator extends StatelessWidget {
  final bool isSelected;

  const _SelectIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryColor
            : AppColors.white.withValues(alpha: 0.85),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.white : AppColors.greyScale.grey400,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.15),
            blurRadius: 3,
          ),
        ],
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 14)
          : null,
    );
  }
}
