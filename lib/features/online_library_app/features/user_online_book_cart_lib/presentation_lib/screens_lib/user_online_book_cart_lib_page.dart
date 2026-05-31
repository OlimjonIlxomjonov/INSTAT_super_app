import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/technical_work_flash_bar.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/short_book_details_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_lib_style_custom_bottom_sheet/online_lib_style_custom_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/general_widgets/payment_open_bottom_sheet/payment_open_bottom_sheet_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/cart/cart_state.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/user_cart_event.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserOnlineBookCartLibPage extends StatefulWidget {
  const UserOnlineBookCartLibPage({super.key});

  @override
  State<UserOnlineBookCartLibPage> createState() =>
      _UserOnlineBookCartLibPageState();
}

class _UserOnlineBookCartLibPageState extends State<UserOnlineBookCartLibPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    final isLoading = cartState is CartLoading;
    final isError = cartState is CartError;
    final items = cartState is CartLoaded ? cartState.response.data : null;
    final itemCount = items?.length ?? 5;
    final totalPrice =
        items?.fold<num>(0, (sum, item) => sum + item.price) ?? 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Savat'),
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
                        return ShortBookDetailsWg(
                          imagePath: thumbnail,
                          bookName: item?.name ?? 'Placeholder Book Title',
                          bookAuthor: item?.author.name ?? 'Author Name',
                          newPrice: item != null
                              ? '${item.price} UZS'
                              : '000 000 UZS',
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: appH(30)),
                  _buildSimpleRow('Umumiy mahsulotlar', '$itemCount ta'),
                  SizedBox(height: 12),
                  Divider(color: AppColors.greyScale.grey200),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Umumiy summa',
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
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: 'Sotib olish - $totalPrice UZS',
        onTap: () {
          // onlineLibStyleCustomBottomSheetWg(
          //   context,
          //   headerTitle: 'To\'lov turi',
          //   child: PaymentOpenBottomSheetWg(),
          // );
          technicalWorkFlushBar(context, 'Tez orada!');
        },
      ),
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
