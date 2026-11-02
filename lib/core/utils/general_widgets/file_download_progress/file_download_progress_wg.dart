import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';

class FileDownloadProgressWg extends StatelessWidget {
  final double? progress;
  final double size;

  const FileDownloadProgressWg({super.key, this.progress, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: progress ?? 0),
              duration: const Duration(milliseconds: 200),
              builder: (_, value, _) => CircularProgressIndicator(
                value: progress == null ? null : value,
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
                backgroundColor: AppColors.greyScale.grey200,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          Icon(
            Icons.close_rounded,
            size: size * 0.42,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
