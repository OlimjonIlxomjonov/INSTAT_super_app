import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';

class ArticleAddAuthorView extends StatelessWidget {
  const ArticleAddAuthorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          spacing: 14,
          crossAxisAlignment: .start,
          children: [
            /// NAME
            AuthTextFieldWg(
              label: 'Muallif ismi',
              title: 'Ismi',
              controller: TextEditingController(),
              leadingIcon: IconlyLight.profile,
            ),

            /// SURNAME
            AuthTextFieldWg(
              label: 'Muallif familiyasi',
              title: 'Familiya',
              controller: TextEditingController(),
              leadingIcon: IconlyLight.profile,
            ),

            /// DEGREE
            CustomDropDownMenuWg(
              title: 'Ilmiy Daraja',
              hintText: 'Professor',
              leadingIcon: Icons.school_outlined,
            ),

            /// COMPANY
            AuthTextFieldWg(
              label: 'Tashkilot nomini yozing',
              title: 'Tashkilot',
              controller: TextEditingController(),
              leadingIcon: Icons.corporate_fare,
            ),

            /// email
            AuthTextFieldWg(
              label: 'example@gmail.com',
              title: 'Elektron pochta',
              controller: TextEditingController(),
              leadingIcon: IconlyLight.message,
            ),

            /// phone number
            AuthTextFieldWg(
              label: 'Toshkent, O\'zbekiston',
              title: 'Shahar, davlar',
              controller: TextEditingController(),
              leadingIcon: IconlyLight.location,
            ),

            /// phone number
            AuthTextFieldWg(
              label: '+998 90 123 45 67',
              title: 'Shahar, davlar',
              controller: TextEditingController(),
              leadingIcon: IconlyLight.call,
            ),

            /// ORCID
            AuthTextFieldWg(
              label: '0000 0000 0000 0000 ID',
              title: 'ORCID',
              controller: TextEditingController(),
              leadingIcon: LineIcons.identificationCard,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
