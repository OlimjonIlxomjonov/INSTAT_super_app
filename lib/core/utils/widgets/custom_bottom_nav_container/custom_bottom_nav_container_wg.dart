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

  const CustomBottomNavContainerWg({
    super.key,
    required this.buttonText,
    this.anotherButton,
    required this.onTap,
    this.leadingIcon,
    this.onCartTap,
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
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: leadingIcon != null
                      ? Icon(leadingIcon, size: 20)
                      : null,
                  label: Text(
                    buttonText,
                    key: ValueKey<String>(buttonText),
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(width: appW(12)),
              if (anotherButton != null)
                Expanded(
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
