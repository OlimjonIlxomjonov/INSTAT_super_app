import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/scientific_articles_app/dummy_models/magazine_model.dart';

class SliverMagazineGridWg extends StatelessWidget {
  final List<MagazineModel> items;

  const SliverMagazineGridWg({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // maxCrossAxisExtent: 250,
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: 0.6,
        ),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Column(
            children: [
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 0.78,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/temp_book.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(item.bookTitle, style: CustomTextStyles.h3),
                    SizedBox(height: 4),
                    Text(
                      item.bookDate,
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
