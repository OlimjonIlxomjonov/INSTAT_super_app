import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class ShortBookDetailsWg extends StatelessWidget {
  final String bookName, bookAuthor;
  final String? bookType, newPrice, oldPrice;
  final String? imagePath;

  const ShortBookDetailsWg({
    super.key,
    required this.bookName,
    required this.bookAuthor,
    this.bookType,
    this.newPrice,
    this.oldPrice,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 15),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          /// left side image
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150, minHeight: 180),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: imagePath != null && imagePath!.isNotEmpty
                  ? Image.network(
                      imagePath!,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 180,
                      errorBuilder: (ctx, obj, stk) {
                        return Container(
                          width: 150,
                          height: 180,
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    )
                  : Container(
                      width: 150,
                      height: 180,
                      color: Colors.grey.shade200,
                    ),
            ),
          ),
          SizedBox(width: 12),

          /// right side content
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  bookName,
                  style: AppTextStyles.source.semiBold(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  bookAuthor,
                  style: AppTextStyles.source.regular(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                SizedBox(height: 12),
                if (bookType != null)
                  Container(
                    padding: .symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.greyScale.grey50,
                      borderRadius: .circular(6),
                    ),
                    child: Text(
                      bookType!,
                      style: AppTextStyles.source.medium(fontSize: 13),
                    ),
                  )
                else
                  Row(
                    children: [
                      Text(
                        newPrice ?? '',
                        style: AppTextStyles.source.regular(
                          fontSize: 14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        oldPrice ?? '',
                        style: TextStyle(
                          decoration: .lineThrough,
                          fontWeight: .w300,
                          color: AppColors.greyScale.grey600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
