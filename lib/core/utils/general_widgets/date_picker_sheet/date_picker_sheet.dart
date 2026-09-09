import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

/// Bottom sheet ichidagi kalendar. Material'ning `showDatePicker` dialogidan
/// farqli o'laroq loyihaning qolgan sheet uslubiga mos keladi.
Future<DateTime?> showDatePickerSheet(
  BuildContext context, {
  required String title,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final first = firstDate ?? DateTime(1950);
  final last = lastDate ?? DateTime(DateTime.now().year + 10, 12, 31);

  // initialDate chegaralardan tashqarida bo'lsa CalendarDatePicker assert
  // bilan yiqiladi — shuning uchun majburan ichkariga siqamiz.
  var initial = initialDate ?? DateTime.now();
  if (initial.isBefore(first)) initial = first;
  if (initial.isAfter(last)) initial = last;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _DatePickerSheet(
      title: title,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    ),
  );
}

class _DatePickerSheet extends StatefulWidget {
  const _DatePickerSheet({
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _selected = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(child: Text(widget.title, style: CustomTextStyles.h3)),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          CalendarDatePicker(
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            onDateChanged: (date) => setState(() => _selected = date),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(_selected),
                child: Text(localization.requestSelectAction),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
