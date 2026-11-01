import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/onboarding/screens/components/log_in_options_component.dart';

class LogInOptionsPage extends StatelessWidget {
  final SessionEndReason? sessionEndReason;

  const LogInOptionsPage({super.key, this.sessionEndReason});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: TDeviceUtils.lightStatusBarIcons,
      child: Scaffold(
        backgroundColor: AppColors.splashBackgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            LogInOptionsComponent(),
            if (sessionEndReason != null)
              _SessionNotice(reason: sessionEndReason!),
          ],
        ),
      ),
    );
  }
}

class _SessionNotice extends StatefulWidget {
  final SessionEndReason reason;

  const _SessionNotice({required this.reason});

  @override
  State<_SessionNotice> createState() => _SessionNoticeState();
}

class _SessionNoticeState extends State<_SessionNotice> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isExpired = widget.reason == SessionEndReason.expired;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, -0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
          child: !_isVisible
              ? const SizedBox.shrink()
              : TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * -16),
                      child: child,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isExpired
                                    ? localization.sessionExpiredTitle
                                    : localization.sessionEndedTitle,
                                style: AppTextStyles.source.semiBold(
                                  fontSize: 15,
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isExpired
                                    ? localization.sessionExpiredDescription
                                    : localization.sessionEndedDescription,
                                style: AppTextStyles.source.regular(
                                  fontSize: 13,
                                  color: AppColors.white.withValues(
                                    alpha: 0.85,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => setState(() => _isVisible = false),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: AppColors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
