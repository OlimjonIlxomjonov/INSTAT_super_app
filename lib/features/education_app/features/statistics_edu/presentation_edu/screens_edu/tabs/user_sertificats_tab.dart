import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/body_container.dart';

class UserSertificatsTab extends StatelessWidget {
  const UserSertificatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BodyContainer(
            title: 'Sertifikatlar',
            body: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                childAspectRatio: 1.33,
              ),
              itemBuilder: (context, index) {
                return Image.asset('assets/images/sertificat_temp.png');
              },
            ),
          ),
        ],
      ),
    );
  }
}
