import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_test/lesson_test_option_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';

class TestOptionListWg extends StatelessWidget {
  final List<LessonTestOptionEntity> options;
  final int? selectedOptionId;
  final bool isAnswered;
  final bool? isCorrect;
  final Function(int optionId)? onSelectOption;

  const TestOptionListWg({
    super.key,
    required this.options,
    required this.selectedOptionId,
    this.isAnswered = false,
    this.isCorrect,
    this.onSelectOption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        options.length,
        (index) {
          final option = options[index];
          final isSelected = selectedOptionId == option.id;
          
          Color? backgroundColor;
          Color? borderColor;
          Widget? actionIcon;

          if (isAnswered && isSelected) {
            backgroundColor = isCorrect == true
                ? AppColors.green.withValues(alpha: 0.1)
                : AppColors.red.withValues(alpha: 0.1);
            borderColor = isCorrect == true ? AppColors.green : AppColors.red;
            actionIcon = Icon(
              isCorrect == true ? Icons.check_circle : Icons.cancel,
              color: isCorrect == true ? AppColors.green : AppColors.red,
            );
          } else if (isAnswered) {
             backgroundColor = Colors.transparent;
             borderColor = AppColors.greyScale.grey200;
             actionIcon = Icon(
               Icons.circle_outlined, 
               color: AppColors.greyScale.grey300,
             );
          } else {
             actionIcon = Checkbox(
              value: isSelected,
              shape: const CircleBorder(),
              onChanged: onSelectOption != null 
                  ? (temp) => onSelectOption!(option.id) 
                  : null,
            );
          }

          return DefaultCustomTileWg(
            onTap: onSelectOption != null && !isAnswered
                ? () => onSelectOption!(option.id)
                : () {},
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            tileAction: actionIcon,
            tileTitle: option.text,
          );
        },
      ),
    );
  }
}
