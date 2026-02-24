import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class UserInfoTab extends StatelessWidget {
  const UserInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> userInfoCard = [
      'Reyting',
      'Ball',
      'Medallar',
      'Sertifikat',
    ];
    const userTrailing = ['#1', '3 246 ⭐', '12 🏅', '16 ta'];
    final List<String> userStudyProcess = [
      'Tugallangan kurslar',
      'Faol kurslar',
      'Tugatish foizi',
      'Umumiy ta’lim vaqti',
    ];
    const userStudyProcessTrailing = ['23 ta', '5 ta', '96%', '467 soat'];

    return ListView(
      children: [
        userProfileInfoCardWg(
          'Foydalanuvchi ma’lumoti',
          userInfoCard,
          userTrailing,
        ),
        SizedBox(height: appH(12)),
        userProfileInfoCardWg(
          'O’qish jarayoni',
          userStudyProcess,
          userStudyProcessTrailing,
        ),
        SizedBox(height: appH(20)),
      ],
    );
  }

  Widget userProfileInfoCardWg(
    String title,
    List<String> userInfoCard,
    List<String> userTrailing,
  ) {
    return Container(
      width: double.infinity,
      padding: .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        border: .all(color: AppColors.greyScale.grey200),
      ),
      child: Column(
        spacing: appH(10),
        crossAxisAlignment: .start,
        children: [
          Text(title, style: AppTextStyles.source.medium(fontSize: 17)),
          ...List.generate(
            userInfoCard.length,
            (index) => Row(
              children: [
                Icon(Icons.star, color: AppColors.primaryColor),
                SizedBox(width: appW(8)),
                Text(
                  userInfoCard[index],
                  style: AppTextStyles.source.medium(
                    fontSize: 14,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  userTrailing[index],
                  style: AppTextStyles.source.medium(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
