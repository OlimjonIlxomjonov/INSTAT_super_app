import 'package:flutter/material.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/create_article_order_use_case.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/usecase/add_article/get_site_data_value_use_case.dart';
import 'package:url_launcher/url_launcher.dart';

const String _paymentMethodClick = 'click';
const String _paymentMethodPayme = 'payme';
const String _reviewPriceKey = 'review_price';

/// Allaqachon yaratilgan, to'lov kutayotgan maqola uchun to'lov tanlovi.
/// Sehrgardagi [ArticlePaymentOptionsWg] dan farqi — bu yerda maqola
/// saqlangan bo'ladi, shuning uchun faqat create-order chaqiriladi.
class ArticlePayOptionsWg extends StatefulWidget {
  final int reviewId;
  final VoidCallback onSuccess;

  const ArticlePayOptionsWg({
    super.key,
    required this.reviewId,
    required this.onSuccess,
  });

  @override
  State<ArticlePayOptionsWg> createState() => _ArticlePayOptionsWgState();
}

class _ArticlePayOptionsWgState extends State<ArticlePayOptionsWg> {
  String? _price;
  String? _payingMethod;

  @override
  void initState() {
    super.initState();
    _fetchPrice();
  }

  Future<void> _fetchPrice() async {
    try {
      final price = await sl<GetSiteDataValueUseCase>()(key: _reviewPriceKey);
      if (mounted) setState(() => _price = price);
    } catch (_) {
      //! Narx ko'rsatilmasa ham to'lovni boshlash mumkin
    }
  }

  Future<void> _pay(String paymentMethod) async {
    if (_payingMethod != null) return;
    setState(() => _payingMethod = paymentMethod);
    try {
      final order = await sl<CreateArticleOrderUseCase>()(
        CreateArticleOrderParams(
          reviewId: widget.reviewId,
          paymentMethod: paymentMethod,
        ),
      );
      if (!mounted) return;
      AppRoute.close();
      if (order.redirectUrl.isNotEmpty) {
        await launchUrl(
          Uri.parse(order.redirectUrl),
          mode: LaunchMode.externalApplication,
        );
      }
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() => _payingMethod = null);
      final localization = AppLocalizations.of(context)!;
      errorFlushBar(
        context,
        apiErrorMessage(e) ?? localization.savingError,
        details: apiErrorDetails(e),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_price != null) ...[
            Text(
              localization.reviewPrice(formatPrice(_price!)),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: _buildPaymentMethod(
                  AppImages.clickPayment,
                  _paymentMethodClick,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentMethod(
                  AppImages.paymePayment,
                  _paymentMethodPayme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String imagePath, String paymentMethod) {
    final isLoading = _payingMethod == paymentMethod;
    return GestureDetector(
      onTap: isLoading ? null : () => _pay(paymentMethod),
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
  }
}
