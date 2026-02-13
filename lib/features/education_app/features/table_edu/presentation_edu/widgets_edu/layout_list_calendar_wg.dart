import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class SimpleWeekCalendar extends StatefulWidget {
  const SimpleWeekCalendar({super.key});

  @override
  State<SimpleWeekCalendar> createState() => _SimpleWeekCalendarState();
}

class _SimpleWeekCalendarState extends State<SimpleWeekCalendar> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final monthTitle = DateFormat('MMMM yyyy').format(selectedDate);

    final weekStart = _startOfWeek(selectedDate);
    final weekDays = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: appW(20),
              vertical: appH(20),
            ),
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
                      selectedDate = selectedDate.subtract(
                        const Duration(days: 7),
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
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
          ),

          /// WEEK ROW
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: .symmetric(horizontal: appW(20)),
              child: Row(
                spacing: appW(10),
                children: weekDays.map((date) {
                  final isSelected = _isSameDay(date, selectedDate);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      width: appW(64),
                      height: appH(80),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EE').format(date),
                            style: AppTextStyles.source.medium(
                              fontSize: 14,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.greyScale.grey400,
                            ),
                          ),
                          Text(
                            "${date.day}",
                            style: AppTextStyles.source.semiBold(
                              fontSize: 24,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.greyScale.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
