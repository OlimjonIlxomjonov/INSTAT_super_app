import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_linear_indicator/custom_linear_indicator_wg.dart';
import 'package:my_template/core/utils/responsiveness/responsive.dart';

import '../../../../features/online_library_app/features/offline_books_lib/domain/entity/offline_book_entity.dart';

class ActiveBooksWg extends StatelessWidget {
  final VoidCallback onTap;
  final bool showCircularProgBar;
  final OfflineBookEntity data;
  final String categoryName;

  const ActiveBooksWg({
    super.key,
    required this.onTap,
    this.showCircularProgBar = true,
    required this.data,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    final progress = data.pagesCount > 0
        ? (data.currentPage / data.pagesCount).clamp(0.0, 1.0)
        : 0.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 90, maxHeight: 100),
        margin: .only(bottom: 12, right: isTablet ? 20 : 0),
        padding: .symmetric(horizontal: 8, vertical: isTablet ? 8 : 5),
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "${ApiUrls.imageUrlBase}${data.bookThumbnails.first.file}",
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                    errorBuilder: (_, obj, t) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              flex: Responsive.isMobile(context) ? 2 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: .spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  /// category name
                  AutoSizeText(
                    categoryName,
                    style: AppTextStyles.source.medium(
                      fontSize: 12,
                      color: AppColors.primaryColor,
                    ),
                  ),

                  /// course name
                  Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),

                  /// desc
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Sahifa (${data.currentPage} / ${data.pagesCount})",
                        style: CustomTextStyles.h4,
                      ),
                      AutoSizeText(
                        "${(progress * 100).toInt()} %",
                        style: AppTextStyles.source.regular(
                          fontSize: 12,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ],
                  ),
                  CustomLinearIndicatorWg(progressIndicator: progress * 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
