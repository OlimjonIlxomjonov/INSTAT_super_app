import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';

class DayCellComponent extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final ValueNotifier<DateTime> selectedDate;

  const DayCellComponent({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<DateTime>(
        valueListenable: selectedDate,
        builder: (_, selected, __) {
          final isSelected =
              selected.year == date.year &&
              selected.month == date.month &&
              selected.day == date.day;

          return GestureDetector(
            onTap: isCurrentMonth ? () => selectedDate.value = date : null,
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.white
                          : isCurrentMonth
                          ? AppColors.black
                          : AppColors.greyScale.grey400,
                      fontWeight: FontWeight.w600,
                    ),

                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
