import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';

class SertificatsSettingsComponent extends StatelessWidget {
  const SertificatsSettingsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Sertifikatlar'),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: .all(12),
                decoration: BoxDecoration(
                  borderRadius: .circular(16),
                  border: .all(color: AppColors.greyScale.grey200),
                  color: AppColors.greyScale.grey50,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Kategoriya nomi',
                      style: AppTextStyles.source.medium(
                        fontSize: 14,
                        color: AppColors.greyScale.grey600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Statistika (Tarmoqlar va sohalar bo’yicha)',
                      style: AppTextStyles.source.semiBold(fontSize: 17),
                    ),
                    SizedBox(height: 16),
                    Image.asset('assets/images/sertificat_temp.png'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
