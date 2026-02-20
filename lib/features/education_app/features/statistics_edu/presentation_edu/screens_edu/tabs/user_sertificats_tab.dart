import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/body_container.dart';

class UserSertificatsTab extends StatelessWidget {
  const UserSertificatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
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
    );
  }
}
