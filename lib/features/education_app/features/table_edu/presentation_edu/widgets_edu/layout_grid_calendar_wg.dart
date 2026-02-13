import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class SimpleMonthCalendar extends StatefulWidget {
  const SimpleMonthCalendar({super.key});

  @override
  State<SimpleMonthCalendar> createState() => _SimpleMonthCalendarState();
}

class _SimpleMonthCalendarState extends State<SimpleMonthCalendar> {
  DateTime focusedMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final monthTitle = DateFormat('MMMM yyyy').format(focusedMonth);
    final days = _buildMonthDays(focusedMonth);

    return Container(
      margin: .symmetric(horizontal: appW(20), vertical: appH(20)),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyScale.grey50,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: AppColors.white),
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      focusedMonth = DateTime(
                        focusedMonth.year,
                        focusedMonth.month - 1,
                      );
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    monthTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.source.medium(
                      fontSize: 14,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: AppColors.white),
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      focusedMonth = DateTime(
                        focusedMonth.year,
                        focusedMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: appH(8)),

          /// WEEKDAY LABELS
          const Row(
            children: [
              _WeekLabel("MO"),
              _WeekLabel("TU"),
              _WeekLabel("WE"),
              _WeekLabel("TH"),
              _WeekLabel("FR"),
              _WeekLabel("SA"),
              _WeekLabel("SU"),
            ],
          ),

          SizedBox(height: appH(8)),

          /// DAYS GRID
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 7,
            ),
            itemBuilder: (context, index) {
              final date = days[index];
              final isSelected = _isSameDay(date, selectedDate);
              final isCurrentMonth = date.month == focusedMonth.month;

              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2F6FE4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${date.day}",
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : isCurrentMonth
                          ? Colors.black87
                          : Colors.grey[400],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build full month grid starting from Monday
  List<DateTime> _buildMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final startOffset = (firstDay.weekday + 6) % 7;
    final startDate = firstDay.subtract(Duration(days: startOffset));

    return List.generate(42, (index) => startDate.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _WeekLabel extends StatelessWidget {
  final String text;

  const _WeekLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.source.medium(
          fontSize: 14,
          color: AppColors.greyScale.grey600,
        ),
      ),
    );
  }
}
