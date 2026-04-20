import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';

class BookGridItem extends StatelessWidget {
  const BookGridItem({
    super.key,
    required this.type,
    required this.imagePath,
    required this.author,
    required this.title,
    this.rating,
    this.price,
    this.oldPrice,
    this.progress = 0.0,
    this.currentPage,
    this.totalPages,
    this.shelfNumber,
    this.rowNumber,
    this.onFavTap,
    this.onTap,
  });

  final BookCardType type;
  final String imagePath;
  final String author;
  final String title;

  // Market specific
  final double? rating;
  final String? price;
  final String? oldPrice;
  final VoidCallback? onFavTap;

  // Bought specific
  final double progress; // 0.0 to 1.0
  final int? currentPage;
  final int? totalPages;

  // Library specific
  final int? shelfNumber;
  final int? rowNumber;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCoverStack(),
          const SizedBox(height: 10),
          _buildAuthorAndTitle(),
          const SizedBox(height: 8),
          _buildBottomSection(),
        ],
      ),
    );
  }

  /// 1. THE IMAGE COVER STACK
  Widget _buildCoverStack() {
    return AspectRatio(
      aspectRatio: 0.78,
      child: Stack(
        children: [
          // Background Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.image_not_supported, size: 26),
                      );
                    },
                  )
                : Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          // Rating Badge (Market only)
          if (type == BookCardType.market && rating != null)
            Positioned(
              top: 10,
              left: 10,
              child: _buildGlassBadge(
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16, color: AppColors.orange),
                    const SizedBox(width: 4),
                    Text(
                      rating!.toStringAsFixed(1).replaceAll('.', ','),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Favorite Button (Market only)
          if (type == BookCardType.market)
            Positioned(
              top: 10,
              right: 10,
              child: _buildGlassBadge(
                isCircle: true,
                child: InkWell(
                  onTap: onFavTap,
                  child: const Icon(Icons.favorite_border_rounded, size: 20),
                ),
              ),
            ),

          // Price/Discount Badge (Top-right or Bottom-right per your design)
          if (type == BookCardType.market && oldPrice != null)
            Positioned(
              bottom: 5,
              right: 5,
              child: _buildGlassBadge(
                child: Text(
                  price ?? '',
                  style: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 2. AUTHOR & TITLE
  Widget _buildAuthorAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.source.regular(
            fontSize: 13,
            color: AppColors.greyScale.grey600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.source.medium(fontSize: 15),
        ),
      ],
    );
  }

  /// 3. CONDITIONAL BOTTOM SECTION
  Widget _buildBottomSection() {
    switch (type) {
      case BookCardType.bought:
        return _buildBoughtProgress();
      case BookCardType.market:
        return _buildMarketPricing();
      case BookCardType.library:
        return _buildLibraryLocation();
    }
  }

  Widget _buildBoughtProgress() {
    return Column(
      children: [
        Row(
          children: [
            Text('Sahifa', style: _subStyle()),
            Text(
              ' ($currentPage/$totalPages)',
              style: _subStyle(color: AppColors.greyScale.grey400),
            ),
            const Spacer(),
            Text('${(progress * 100).toInt()}%', style: _subStyle()),
          ],
        ),
        const SizedBox(height: 6),
        CustomLinearIndicatorWg(progressIndicator: progress),
      ],
    );
  }

  Widget _buildMarketPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (oldPrice != null)
          Text(
            oldPrice!,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          )
        else
          Text(
            price ?? '',
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildLibraryLocation() {
    return Column(
      children: [
        _locationRow('Javon raqami', shelfNumber?.toString() ?? '-'),
        const SizedBox(height: 4),
        _locationRow('Tokcha raqami', rowNumber?.toString() ?? '-'),
      ],
    );
  }

  // --- HELPERS ---

  Widget _locationRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _subStyle()),
        Text(
          value,
          style: _subStyle(color: AppColors.greyScale.grey600, isValue: true),
        ),
      ],
    );
  }

  TextStyle _subStyle({Color? color, bool isValue = false}) {
    return AppTextStyles.source
        .regular(fontSize: 14, color: color ?? AppColors.greyScale.grey600)
        .copyWith(fontWeight: isValue ? FontWeight.w500 : FontWeight.w300);
  }

  Widget _buildGlassBadge({required Widget child, bool isCircle = false}) {
    return Container(
      padding: EdgeInsets.all(isCircle ? 8 : 6).copyWith(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: child,
    );
  }
}
