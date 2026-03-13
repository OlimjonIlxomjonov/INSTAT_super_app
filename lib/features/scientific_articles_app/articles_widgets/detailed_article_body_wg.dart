import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';

class DetailedArticleBodyWg extends StatelessWidget {
  const DetailedArticleBodyWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        /// title & desc
        Text(
          '#3465',
          style: AppTextStyles.source.medium(
            fontSize: 16,
            color: AppColors.greyScale.grey600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sun’iy intellekt yordamida ilmiy tadqiqot samaradorligini oshirish',
          style: CustomTextStyles.h2,
        ),
        const SizedBox(height: 8),
        Text(
          'Iqtisodiyot va innovatsion texnologiyalar',
          style: AppTextStyles.source.medium(
            fontSize: 14,
            color: AppColors.greyScale.grey600,
          ),
        ),
        const SizedBox(height: 24),
        Text('Mualliflar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        Container(
          padding: const .symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: .all(color: AppColors.greyScale.grey200),
            borderRadius: .circular(12),
          ),
          child: Row(
            spacing: 12,
            children: [
              CircleAvatar(radius: 25),
              Column(
                spacing: 5,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Author Name',
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  Text(
                    '+99899 889 90 90',
                    style: AppTextStyles.source.regular(
                      fontSize: 12,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Annotatsiya', style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        Text(
          'Ushbu maqolada O‘zbekiston iqtisodiyotining raqamlashuv jarayonlari, uning bugungi holati va kelajakdagi rivojlanish istiqbollari tahlil qilinadi. Raqamli texnologiyalarning iqtisodiy o‘sishga ta’siri va innovatsion yondashuvlar muhimligi yoritilgan. Shuningdek, sohadagi mavjud muammolar va ularni bartaraf etish bo‘yicha tavsiyalar keltirilgan.',
          style: AppTextStyles.source.regular(
            fontSize: 14,
            color: AppColors.greyScale.grey600,
          ),
        ),
        const SizedBox(height: 24),
        Text('Kalit so’zlar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        Container(
          padding: .symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: .circular(6),
            color: AppColors.greyScale.grey50,
          ),
          child: Text('Kvant mexanikasi'),
        ),

        const SizedBox(height: 24),
        Text('Hujjatlar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        SelectedFileContainerWg(),
        const SizedBox(height: 20),
      ],
    );
  }
}
