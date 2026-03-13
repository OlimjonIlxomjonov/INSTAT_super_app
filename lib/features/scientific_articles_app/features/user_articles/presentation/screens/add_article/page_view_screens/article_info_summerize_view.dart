import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/scientific_articles_app/articles_widgets/detailed_article_body_wg.dart';

class ArticleInfoSummerizeView extends StatelessWidget {
  const ArticleInfoSummerizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// BODY
            DetailedArticleBodyWg(),

            /// REST of the body
            Container(
              padding: const .symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey50,
                border: .all(color: AppColors.greyScale.grey200),
                borderRadius: .circular(12),
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  /// header
                  Row(
                    children: [
                      Icon(
                        Icons.corporate_fare,
                        color: AppColors.greyScale.grey600,
                      ),
                      Text(' Yakuniy tasdiqlash', style: CustomTextStyles.h3),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ///body
                  Row(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .start,
                    children: [
                      Checkbox.adaptive(
                        fillColor: WidgetStateProperty.all(
                          AppColors.primaryColor,
                        ),
                        value: true,
                        onChanged: (newValue) {},
                      ),
                      Expanded(
                        child: Text(
                          "Originallik bayonoti: Maqola originalligini tasdiqlayman, ushbu qo'lyozma avval chop etilmagan va hozirda boshqa joyda ko'rib chiqilmayapti.Originallik bayonoti: Maqola originalligini tasdiqlayman, ushbu qo'lyozma avval chop etilmagan va hozirda boshqa joyda ko'rib chiqilmayapti.",
                          style: CustomTextStyles.h3half.copyWith(
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// FREE BOTTOM SPACE
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
