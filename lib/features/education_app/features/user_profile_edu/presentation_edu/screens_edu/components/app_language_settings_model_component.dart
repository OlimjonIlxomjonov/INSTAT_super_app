import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/services/language_storage/language_service_storage.dart';
import 'package:my_template/core/streams/general_streams.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class AppLanguageSettingsModelComponent extends StatefulWidget {
  const AppLanguageSettingsModelComponent({super.key});

  @override
  State<AppLanguageSettingsModelComponent> createState() =>
      _AppLanguageSettingsModelComponentState();
}

class _AppLanguageSettingsModelComponentState
    extends State<AppLanguageSettingsModelComponent> {
  int isIndex = 0;

  final List<String> languageTitle = ['O’zbek tili', 'Ingliz tili', 'Rus tili'];
  final List<String> languageLeading = [
    AppVectors.uzbekistanFlag,
    AppVectors.ukFlag,
    AppVectors.russiaFlag,
  ];

  final List<Locale> languageLocale = const [
    Locale('uz'),
    Locale('uz'),
    Locale('ru'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedLocale = await LanguageServiceStorage.loadLocale();

    // if (savedLocale == null) return;

    final index = languageLocale.indexWhere(
      (locale) => locale.languageCode == savedLocale.languageCode,
    );

    if (index != -1) {
      setState(() {
        isIndex = index;
      });
    }
  }

  Future<void> _selectLanguage(int index) async {
    setState(() => isIndex = index);

    final currentLocale = languageLocale[index];
    await LanguageServiceStorage.saveLocale(currentLocale);
    GeneralStream.languageStream.add(currentLocale);
  }

  @override
  Widget build(BuildContext context) {
    TDeviceUtils.systemNavigationBar(AppColors.white);
    return SafeArea(
      child: Padding(
        padding: AppPadding.horizontal20x(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: 40,
                height: 4,
                color: AppColors.greyScale.grey200,
              ),
            ),
            Text(
              'Ilova tili',
              style: AppTextStyles.source.semiBold(fontSize: 17),
            ),
            SizedBox(height: appH(12)),
            ...List.generate(languageLeading.length, (index) {
              final isChecked = isIndex == index;

              return GestureDetector(
                behavior: .opaque,
                onTap: () => _selectLanguage(index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.greyScale.grey200),
                  ),
                  child: ListTile(
                    leading: SvgPicture.asset(languageLeading[index]),
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      languageTitle[index],
                      style: AppTextStyles.source.medium(fontSize: 14),
                    ),
                    trailing: Checkbox(
                      value: isChecked,
                      activeColor: AppColors.primaryColor,
                      side: BorderSide(color: AppColors.transparent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onChanged: (checked) {},
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
