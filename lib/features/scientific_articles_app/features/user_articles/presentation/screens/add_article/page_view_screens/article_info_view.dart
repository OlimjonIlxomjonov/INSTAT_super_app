import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';

class ArticleInfoView extends StatelessWidget {
  const ArticleInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// TEXT AREA
            Text('Sarlavha', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            EduCustomTextAreaWg(
              hintText: 'Maqola sarlavhasini kiriting...',
              helperText: 'Mavzuni qisqa va tushunarli qilib ifodalang.',
            ),

            SizedBox(height: 14),

            /// UDK RAQAMI
            Text('UDK', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            AuthTextFieldWg(
              label: 'UDK raqamini kiriting',
              controller: TextEditingController(),
            ),

            SizedBox(height: 14),

            /// DROP DOWNS
            CustomDropDownMenuWg(
              title: 'Maqola turi',
              hintText: 'Turini tanlang',
            ),
            SizedBox(height: 14),

            CustomDropDownMenuWg(
              title: 'Maqolani tili',
              hintText: 'O\'zbek tili',
            ),
            SizedBox(height: 14),

            CustomDropDownMenuWg(
              title: 'Jurnal bo’limi',
              hintText: 'Bo\'limni tanlang',
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
