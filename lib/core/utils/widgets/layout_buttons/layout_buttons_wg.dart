import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class LayoutButtonsWg extends StatelessWidget {
  final CalendarLayout layout;
  final ValueChanged<CalendarLayout> onChanged;

  const LayoutButtonsWg({
    super.key,
    required this.layout,
    required this.onChanged,
  });

  bool get isMonth => layout == CalendarLayout.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.greyScale.grey50,
      ),
      child: Row(
        children: [
          _CustomIconButton(
            icon: Icons.grid_view,
            selected: isMonth,
            onTap: () => onChanged(CalendarLayout.month),
          ),
          SizedBox(width: appW(8)),
          _CustomIconButton(
            icon: Icons.list_alt,
            selected: !isMonth,
            onTap: () => onChanged(CalendarLayout.week),
          ),
        ],
      ),
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CustomIconButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: selected ? AppColors.primaryColor : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: selected ? AppColors.white : AppColors.greyScale.grey400,
        ),
      ),
    );
  }
}
