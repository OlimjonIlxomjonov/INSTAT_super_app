import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class StatusContainerWg extends StatelessWidget {
  final IconData icon;
  final String statusTitle;
  final Color iconColor, backgroundColor;

  const StatusContainerWg({
    super.key,
    required this.icon,
    required this.statusTitle,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: .circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          Text(
            statusTitle,
            style: AppTextStyles.source.medium(fontSize: 12, color: iconColor),
          ),
        ],
      ),
    );
  }
}
