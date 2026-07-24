import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

const String _paymentMethodClick = 'click';
const String _paymentMethodPayme = 'payme';

class ArticlePaymentOptionsWg extends StatefulWidget {
  final VoidCallback onSuccess;

  const ArticlePaymentOptionsWg({super.key, required this.onSuccess});

  @override
  State<ArticlePaymentOptionsWg> createState() =>
      _ArticlePaymentOptionsWgState();
}

class _ArticlePaymentOptionsWgState extends State<ArticlePaymentOptionsWg> {
  /// Tracks which button was tapped so the loading spinner only shows on
  /// that one, mirroring BuyBookOptions/PaymentOpenBottomSheetWg.
  String? _selectedPaymentMethod;

  void _submit(BuildContext context, String paymentMethod) {
    setState(() => _selectedPaymentMethod = paymentMethod);
    context.read<AddArticleBloc>().add(
      SubmitArticleForReviewEvent(
        paymentMethod: paymentMethod,
        onSuccess: () {
          AppRoute.close();
          widget.onSuccess();
        },
        onError: (_) {
          if (!mounted) return;
          setState(() => _selectedPaymentMethod = null);
          errorFlushBar(context, AppLocalizations.of(context)!.savingError);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
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
    );
  }

  Widget _buildPaymentMethod(
    String imagePath,
    String paymentMethod,
    BuildContext context,
  ) => BlocBuilder<AddArticleBloc, AddArticleState>(
    builder: (context, state) {
      final isLoading =
          state.isSaving && _selectedPaymentMethod == paymentMethod;
      return GestureDetector(
        onTap: isLoading ? null : () => _submit(context, paymentMethod),
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
