import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class SimpleWeekCalendar extends StatefulWidget {
  final Set<DateTime>? markedDates;

  const SimpleWeekCalendar({super.key, this.markedDates});

  @override
  State<SimpleWeekCalendar> createState() => _SimpleWeekCalendarState();
}

class _SimpleWeekCalendarState extends State<SimpleWeekCalendar> {
  DateTime selectedDate = DateTime.now();
  late DateTime focusedMonth;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    final now = DateTime.now();
    if (now.month == focusedMonth.month && now.year == focusedMonth.year) {
      final todayIndex = now.day - 1;
      // Each cell is appW(64) wide + appW(10) spacing
      final cellWidth = appW(64) + appW(10);
      final todayCenter = todayIndex * cellWidth + (cellWidth / 2);
      final viewportWidth = _scrollController.position.viewportDimension;
      final targetOffset = todayCenter - (viewportWidth / 2);
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthTitle = DateFormat('MMMM yyyy').format(focusedMonth);
    final now = DateTime.now();

    // Generate all days in the focused month
    final daysInMonth = DateUtils.getDaysInMonth(
      focusedMonth.year,
      focusedMonth.month,
    );
    final monthDays = List.generate(
      daysInMonth,
      (index) => DateTime(focusedMonth.year, focusedMonth.month, index + 1),
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
                      focusedMonth = DateTime(
                        focusedMonth.year,
                        focusedMonth.month - 1,
                      );
                      _scrollController.jumpTo(0);
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToToday();
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
                      focusedMonth = DateTime(
                        focusedMonth.year,
                        focusedMonth.month + 1,
                      );
                      _scrollController.jumpTo(0);
                    });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToToday();
                    });
                  },
                ),
              ],
            ),
          ),

          /// DAY ROW — full month, horizontally scrollable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appW(20)),
              child: Row(
                spacing: appW(10),
                children: monthDays.map((date) {
                  final isSelected = _isSameDay(date, selectedDate);
                  final isToday = _isSameDay(date, now);

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
                        border: Border.all(
                          color: isToday && !isSelected
                              ? AppColors.primaryColor
                              : AppColors.greyScale.grey200,
                          width: isToday && !isSelected ? 1.5 : 1,
                        ),
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
                                  : isToday
                                  ? AppColors.primaryColor
                                  : AppColors.greyScale.grey600,
                            ),
                          ),
                          if (widget.markedDates?.contains(
                                DateTime(date.year, date.month, date.day),
                              ) ??
                              false)
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                shape: BoxShape.circle,
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
