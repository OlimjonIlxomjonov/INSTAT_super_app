import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app_utils.dart';
import '../../../l10n/app_localizations.dart';

class CameraAccessDeniedOverlayWg extends StatelessWidget {
  const CameraAccessDeniedOverlayWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    // This overlay is a *sibling* of TestLayout inside the test pages'
    // Stack, so it sits outside that Scaffold's Material. The lesson test
    // gets away with it because openMiniAppSheetFamily wraps its content in
    // a Material, but the final test is pushed via a bare PageRouteBuilder
    // with no Material ancestor at all — which made every Text here render
    // with the debug "missing Material" yellow double underlines. Providing
    // one here keeps the widget self-sufficient wherever it's dropped;
    // MaterialType.transparency paints nothing, so it's visually a no-op.
    return Positioned.fill(
      child: Material(
        type: MaterialType.transparency,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: .circular(20),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.videocam_off_rounded,
                        size: 40,
                        color: AppColors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      localization.cameraAccessDeniedTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.source.semiBold(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization.cameraAccessDeniedSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.source.regular(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: openAppSettings,
                        child: Text(
                          localization.openSettingsButton,
                          style: AppTextStyles.source.medium(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          AppRoute.close();
                        },
                        child: Text(
                          'Close',
                          style: AppTextStyles.source.medium(
                            fontSize: 15,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
