import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

/// Result data returned from the filter bottom sheet.
class FilterBottomSheetResult {
  final int executorType; // 0 = Shaxsiy, 1 = Guruh
  final DateTimeRange? dateRange;
  final Set<String> selectedStatuses;

  const FilterBottomSheetResult({
    required this.executorType,
    this.dateRange,
    required this.selectedStatuses,
  });
}

Future<FilterBottomSheetResult?> showReportsFilterSheet(BuildContext context) {
  return showModalBottomSheet<FilterBottomSheetResult>(
    isScrollControlled: true,
    context: context,
    backgroundColor: AppColors.transparent,
    builder: (_) => const ReportsFilterBottomSheet(),
  );
}

class ReportsFilterBottomSheet extends StatefulWidget {
  const ReportsFilterBottomSheet({super.key});

  @override
  State<ReportsFilterBottomSheet> createState() =>
      _ReportsFilterBottomSheetState();
}

class _ReportsFilterBottomSheetState extends State<ReportsFilterBottomSheet> {
  int _executorType = 0;
  DateTimeRange? _dateRange;
  final Set<String> _selectedStatuses = {};

  static const _statusOptions = [
    'Jarayonda',
    'Bajarildi',
    'Bekor qilindi',
    'Kutilmoqda',
    'Yangi',
    'Qayta ishlangan',
  ];

  void _clearAll() {
    setState(() {
      _executorType = 0;
      _dateRange = null;
      _selectedStatuses.clear();
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      FilterBottomSheetResult(
        executorType: _executorType,
        dateRange: _dateRange,
        selectedStatuses: Set.from(_selectedStatuses),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final primary = AppColors.primaryColor;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.greyScale.grey900,
              // ── range selection line between the two picked dates ──
              surfaceContainerHighest: AppColors.red,
            ),
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: AppColors.green.withOpacity(0.2),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primaryColor;
                }
                return null;
              }),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  String _formatDate(DateTimeRange? range) {
    if (range == null) return 'Sana tanlang';
    final fmt = DateFormat('yyyy-MM-dd');
    return '${fmt.format(range.start)}  —  ${fmt.format(range.end)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ──
            Padding(
              padding: EdgeInsets.only(top: appH(12)),
              child: Container(
                width: appW(40),
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyScale.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // ── Header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appW(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtrlash',
                    style: AppTextStyles.source.semiBold(fontSize: 18),
                  ),
                  IconButton(
                    onPressed: () => AppRoute.close(),
                    icon: const Icon(Icons.close_rounded, size: 22),
                  ),
                ],
              ),
            ),

            // ── Scrollable content ──
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: appW(20),
                  vertical: appH(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Date range (single picker) ──
                    _buildSectionTitle('Sana oralig\'i'),
                    SizedBox(height: appH(10)),
                    _buildDateRow(
                      label: _formatDate(_dateRange),
                      onTap: _pickDateRange,
                    ),

                    SizedBox(height: appH(20)),

                    // ── Status section ──
                    _buildSectionTitle('Holati'),
                    SizedBox(height: appH(10)),
                    _buildStatusChips(),
                  ],
                ),
              ),
            ),

            Divider(height: 1, color: AppColors.greyScale.grey200),

            // ── Footer buttons ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appW(20),
                vertical: appH(16),
              ),
              child: Row(
                children: [
                  // Clear
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: appH(12)),
                        side: BorderSide(color: AppColors.greyScale.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _clearAll,
                      child: Text(
                        'Tozalash',
                        style: AppTextStyles.source.medium(
                          fontSize: 14,
                          color: AppColors.greyScale.grey700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: appW(12)),
                  // Apply
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: appH(12)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _apply,
                      child: Text(
                        'Qo\'llash',
                        style: AppTextStyles.source.medium(
                          fontSize: 14,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ──
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.source.semiBold(
        fontSize: 14,
        color: AppColors.greyScale.grey900,
      ),
    );
  }

  // ── Date row ──
  Widget _buildDateRow({required String label, required VoidCallback onTap}) {
    final hasValue = _dateRange != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: appW(14), vertical: appH(12)),
        decoration: BoxDecoration(
          color: hasValue
              ? AppColors.primaryColor.withValues(alpha: 0.04)
              : null,
          border: Border.all(
            color: hasValue
                ? AppColors.primaryColor.withValues(alpha: 0.25)
                : AppColors.greyScale.grey200,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 20,
              color: hasValue
                  ? AppColors.primaryColor
                  : AppColors.greyScale.grey500,
            ),
            SizedBox(width: appW(10)),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: hasValue
                      ? AppColors.greyScale.grey900
                      : AppColors.greyScale.grey500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.greyScale.grey400,
            ),
          ],
        ),
      ),
    );
  }

  // ── Status chips ──
  Widget _buildStatusChips() {
    return Wrap(
      spacing: appW(8),
      runSpacing: appH(8),
      children: _statusOptions.map((status) {
        final isSelected = _selectedStatuses.contains(status);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedStatuses.remove(status);
              } else {
                _selectedStatuses.add(status);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: appW(14),
              vertical: appH(8),
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.1)
                  : AppColors.greyScale.grey100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.greyScale.grey200,
                width: 1.2,
              ),
            ),
            child: Text(
              status,
              style: AppTextStyles.source.medium(
                fontSize: 13,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.greyScale.grey700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
