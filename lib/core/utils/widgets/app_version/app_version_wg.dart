import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/widgets/app_version/app_version_service.dart';

/// Drawer pastidagi kichik versiya yozuvi.
class AppVersionWg extends StatelessWidget {
  const AppVersionWg({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AppVersionService.shortVersion(),
      builder: (context, snapshot) {
        final version = snapshot.data;
        if (version == null) return const SizedBox.shrink();
        return Text(
          version,
          style: AppTextStyles.source.regular(
            fontSize: 12,
            color: AppColors.greyScale.grey400,
          ),
        );
      },
    );
  }
}
