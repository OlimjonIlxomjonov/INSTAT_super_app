import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class BookGridItem extends StatelessWidget {
  const BookGridItem({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.author,
    required this.title,
    required this.price,
    required this.oldPrice,
    this.onFavTap,
    this.onTap,
  });

  final String imagePath;
  final double rating;
  final String author;
  final String title;
  final String price;
  final String? oldPrice;
  final VoidCallback? onFavTap, onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 0.78,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1).replaceAll('.', ','),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Favorite (top-right)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.95),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onFavTap,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.favorite_border_rounded, size: 20),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 10,
                  bottom: 10,
                  child: oldPrice != null
                      ? Material(
                          color: Colors.white.withValues(alpha: 0.95),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              price,
                              style: AppTextStyles.source.regular(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Author
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

          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.source.medium(fontSize: 15),
          ),

          const SizedBox(height: 4),

          // Price row
          Column(
            crossAxisAlignment: .start,
            children: [
              if (oldPrice == null)
                Text(
                  price,
                  style: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),

              if (oldPrice != null)
                Text(
                  oldPrice!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: .w300,
                    decoration: .lineThrough,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
