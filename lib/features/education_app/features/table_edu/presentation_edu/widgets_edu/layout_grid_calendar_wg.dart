import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/components/day_cell_component.dart';
import 'package:my_template/features/education_app/features/table_edu/presentation_edu/screens_edu/components/week_label_component.dart';

class SimpleMonthCalendar extends StatefulWidget {
  final Set<DateTime>? markedDates;

  const SimpleMonthCalendar({super.key, this.markedDates});

  @override
  State<SimpleMonthCalendar> createState() => _SimpleMonthCalendarState();
}

class _SimpleMonthCalendarState extends State<SimpleMonthCalendar> {
  DateTime focusedMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  final ValueNotifier<DateTime> selectedDateNotifier = ValueNotifier(
    DateTime.now(),
  );
  late String _monthTitle;
  late List<DateTime> _days;

  @override
  void initState() {
    super.initState();
    _monthTitle = DateFormat('MMMM yyyy').format(focusedMonth);
    _days = _buildMonthDays(focusedMonth);
  }

  void _updateMonth(DateTime newMonth) {
    setState(() {
      focusedMonth = newMonth;
      _monthTitle = DateFormat('MMMM yyyy').format(newMonth);
      _days = _buildMonthDays(newMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appW(20), vertical: appH(20)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyScale.grey200),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.greyScale.grey50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.white,
                      ),
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => _updateMonth(
                        DateTime(focusedMonth.year, focusedMonth.month - 1),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _monthTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.source.medium(
                          fontSize: 14,
                          color: AppColors.greyScale.grey600,
                        ),
                      ),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.white,
                      ),
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => _updateMonth(
                        DateTime(focusedMonth.year, focusedMonth.month + 1),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: appH(8)),

              /// WEEKDAY LABELS — already const ✅
              const Row(
                children: [
                  WeekLabelComponent("MO"),
                  WeekLabelComponent("TU"),
                  WeekLabelComponent("WE"),
                  WeekLabelComponent("TH"),
                  WeekLabelComponent("FR"),
                  WeekLabelComponent("SA"),
                  WeekLabelComponent("SU"),
                ],
              ),

              SizedBox(height: appH(8)),

              ...List.generate(5, (rowIndex) {
                return Row(
                  children: List.generate(7, (colIndex) {
                    final date = _days[rowIndex * 7 + colIndex];
                    final hasEvent =
                        widget.markedDates?.contains(
                          DateTime(date.year, date.month, date.day),
                        ) ??
                        false;
                    final now = DateTime.now();
                    final isToday =
                        date.year == now.year &&
                        date.month == now.month &&
                        date.day == now.day;
                    return DayCellComponent(
                      date: date,
                      isCurrentMonth: date.month == focusedMonth.month,
                      selectedDate: selectedDateNotifier,
                      hasEvent: hasEvent,
                      isToday: isToday,
                    );
                  }),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  List<DateTime> _buildMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startOffset = (firstDay.weekday + 6) % 7;
    final startDate = firstDay.subtract(Duration(days: startOffset));
    return List.generate(42, (i) => startDate.add(Duration(days: i)));
  }
}
