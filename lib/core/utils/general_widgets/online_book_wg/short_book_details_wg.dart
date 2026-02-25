import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class ShortBookDetailsWg extends StatelessWidget {
  final String bookName, bookAuthor;
  final String? bookType, newPrice, oldPrice;

  const ShortBookDetailsWg({
    super.key,
    required this.bookName,
    required this.bookAuthor,
    this.bookType,
    this.newPrice,
    this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        ClipRRect(
          borderRadius: .circular(5),
          child: Image.asset(
            'assets/images/temp_book.jpg',
            width: 116,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(bookName, style: AppTextStyles.source.semiBold(fontSize: 16)),
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
      ],
    );
  }
}
