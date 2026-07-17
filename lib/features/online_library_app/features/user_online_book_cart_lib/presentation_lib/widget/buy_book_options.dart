import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/buy_book/buy_book_bloc.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/buy_book/buy_book_state.dart';
import 'package:my_template/features/online_library_app/features/user_online_book_cart_lib/presentation_lib/bloc/user_cart_event.dart';
import 'package:url_launcher/url_launcher.dart';

const String _paymentMethodClick = 'click';
const String _paymentMethodPayme = 'payme';

class BuyBookOptions extends StatefulWidget {
  final List<int> bookIds;

  const BuyBookOptions({super.key, required this.bookIds});

  @override
  State<BuyBookOptions> createState() => _BuyBookOptionsState();
}

class _BuyBookOptionsState extends State<BuyBookOptions> {
  /// Tracks which button was tapped so the loading spinner only shows on
  /// that one, and so the redirect uses the method the user actually chose.
  String? _selectedPaymentMethod;

  void _buyBook(BuildContext context, String paymentMethod) {
    setState(() => _selectedPaymentMethod = paymentMethod);
    context.read<BuyBookBloc>().add(
      BuyBookEvent(
        params: BuyBookParams(
          bookId: widget.bookIds,
          paymentMethod: paymentMethod,
        ),
      ),
    );
  }

  Future<void> _openPaymentUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyBookBloc, BuyBookState>(
      listener: (context, state) {
        if (state is BuyBookLoaded) {
          AppRoute.close();
          _openPaymentUrl(state.entity.redirectUrl);
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPaymentMethod(
                    AppImages.clickPayment,
                    _paymentMethodClick,
                    context,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentMethod(
                    AppImages.paymePayment,
                    _paymentMethodPayme,
                    context,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    String imagePath,
    String paymentMethod,
    BuildContext context,
  ) => BlocBuilder<BuyBookBloc, BuyBookState>(
    builder: (context, state) {
      final isLoading =
          state is BuyBookLoading && _selectedPaymentMethod == paymentMethod;
      return GestureDetector(
        onTap: isLoading ? null : () => _buyBook(context, paymentMethod),
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.greyScale.grey50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.greyScale.grey200),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      );
    },
  );
}
