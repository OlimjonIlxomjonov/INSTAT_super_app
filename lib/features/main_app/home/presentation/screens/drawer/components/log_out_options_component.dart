import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/auth/presentation/screens/log_in_options_page.dart';

class LogOutOptionsComponent extends StatelessWidget {
  const LogOutOptionsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Akkauntdan chiqish',
          style: AppTextStyles.source.medium(
            fontSize: 24,
            color: AppColors.redFailedTaskCard,
          ),
        ),
        Text(
          'Siz rostdan ham akkauntingizdan chiqmoqchimisiz?',
          style: CustomTextStyles.h4,
        ),
        SizedBox(height: 25),
        SafeArea(
          child: Container(
            padding: .symmetric(vertical: appH(20)),
            decoration: BoxDecoration(
              borderRadius: .only(
                topRight: .circular(24),
                topLeft: .circular(24),
              ),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -1),
                  color: AppColors.greyScale.grey200,
                  spreadRadius: 0,
                  blurRadius: 20,
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: .stretch,
                children: [
                  SizedBox(width: appW(12)),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.greyScale.grey400),
                          borderRadius: .circular(12),
                        ),
                      ),
                      onPressed: () {
                        AppRoute.close();
                      },
                      label: Text(
                        'Bekor qilish',
                        style: AppTextStyles.source.medium(
                          fontSize: 14,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: appW(12)),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await TokenStorageServiceImpl().deleteAccessToken();
                        AppRoute.open(LogInOptionsPage());
                      },
                      label: Text(
                        'Tasdiqlash',
                        style: AppTextStyles.source.medium(fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(width: appW(12)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
