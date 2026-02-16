import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class AppLanguageSettingsModelComponent extends StatelessWidget {
  const AppLanguageSettingsModelComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> languageTitle = [
      'O’zbek tili',
      'Ingliz tili',
      'Rus tili',
    ];
    final List<String> languageLeading = [
      AppVectors.uzbekistanFlag,
      AppVectors.ukFlag,
      AppVectors.russiaFlag,
    ];

    return SafeArea(
      child: Padding(
        padding: AppPadding.horizontal20x(),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Center(
              child: Container(
                margin: .symmetric(vertical: 20),
                width: 40,
                height: 4,
                color: AppColors.greyScale.grey200,
              ),
            ),
            Text(
              'Iloba tili',
              style: AppTextStyles.source.semiBold(fontSize: 17),
            ),
            SizedBox(height: appH(12)),
            ...List.generate(
              languageLeading.length,
              (index) => Container(
                margin: .only(bottom: 12),
                padding: .symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: .circular(12),
                  border: .all(color: AppColors.greyScale.grey200),
                ),
                child: ListTile(
                  leading: SvgPicture.asset(languageLeading[index]),
                  contentPadding: .zero,
                  title: Text(
                    languageTitle[index],
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  trailing: Checkbox(value: false, onChanged: (v) {}),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
