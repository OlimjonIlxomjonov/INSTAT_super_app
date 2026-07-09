import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class CustomBottomNavContainerWg extends StatelessWidget {
  final String buttonText;
  final Widget? anotherButton;
  final VoidCallback onTap;
  final VoidCallback? onCartTap;
  final IconData? leadingIcon;
  final bool isLoading;

  const CustomBottomNavContainerWg({
    super.key,
    required this.buttonText,
    this.anotherButton,
    required this.onTap,
    this.leadingIcon,
    this.onCartTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: .symmetric(vertical: appH(20)),
        decoration: BoxDecoration(
          borderRadius: .only(topRight: .circular(24), topLeft: .circular(24)),
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
                flex: anotherButton != null && anotherButton is! SizedBox
                    ? 3
                    : 1,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onTap,
                  icon: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        )
                      : (leadingIcon != null
                            ? Icon(leadingIcon, size: 20)
                            : null),
                  label: Text(
                    isLoading ? '' : buttonText,
                    key: ValueKey<String>(buttonText),
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(width: appW(12)),
              if (anotherButton != null && anotherButton is! SizedBox)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: .only(right: 12),
                    child: anotherButton!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
