import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/annotation_language/annotation_language_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/create_articles_all_sources.dart';

class ArticleAnnotationView extends StatefulWidget {
  const ArticleAnnotationView({super.key});

  @override
  State<ArticleAnnotationView> createState() => _ArticleAnnotationViewState();
}

class _ArticleAnnotationViewState extends State<ArticleAnnotationView> {
  final List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// LANGUAGE SELECTION
            AnnotationLanguageWg(isSelected: isSelected),

            SizedBox(height: 12),

            /// text area
            Text('Annotatsiya (O‘zbek)', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            EduCustomTextAreaWg(
              maxLength: 300,
              hintText: 'Maqolangiz uchun annotatsiyani shu yerga kiriting...',
              helperText:
                  'Maqsad: 250-300 so‘z. Hozirgi hisob minimal miqdordan kam.',
            ),

            SizedBox(height: 12),

            /// Key Words INPUT
            AuthTextFieldWg(
              title: 'Kalit sozlar',
              label: 'Kalit sozlarni kiriting',
              controller: TextEditingController(),
            ),

            const SizedBox(height: 12),

            /// Key words WRAP
            Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                keyWordsDummyTemp.length,
                (index) => Container(
                  margin: const .only(right: 10, bottom: 7),
                  padding: const .only(left: 5),
                  decoration: BoxDecoration(
                    borderRadius: .circular(6),
                    border: .all(color: AppColors.greyScale.grey200),
                  ),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Text(
                        keyWordsDummyTemp[index],
                        style: AppTextStyles.source.medium(
                          fontSize: 13,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: AppColors.greyScale.grey600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
