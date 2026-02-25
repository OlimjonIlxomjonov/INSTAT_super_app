import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

Future<void> onlineLibStyleCustomBottomSheetWg(
  BuildContext context, {
  required String headerTitle,
  required Widget child,
}) async {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: AppColors.transparent,
    builder: (_) {
      TDeviceUtils.systemNavigationBar(AppColors.white);

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerTitle,
                    style: AppTextStyles.source.medium(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      AppRoute.close();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(child: SingleChildScrollView(child: child)),
            ],
          ),
        ),
      );
    },
  );
}
