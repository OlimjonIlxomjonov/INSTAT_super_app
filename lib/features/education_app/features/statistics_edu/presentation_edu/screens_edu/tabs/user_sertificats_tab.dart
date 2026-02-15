import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/body_container.dart';

class UserSertificatsTab extends StatelessWidget {
  const UserSertificatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BodyContainer(
          title: 'Sertifikatlar',
          body: Column(children: []),
        ),
      ],
    );
  }
}
