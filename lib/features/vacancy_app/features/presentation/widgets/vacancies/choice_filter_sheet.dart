import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class ChoiceOption {
  final String value;
  final String label;

  const ChoiceOption(this.value, this.label);
}

Future<String?> showChoiceFilterSheet(
  BuildContext context, {
  required String title,
  required List<ChoiceOption> options,
  String? selected,
}) async {
  final result = await showModalBottomSheet<_ChoiceResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.75,
    ),
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) =>
        _ChoiceSheet(title: title, options: options, selected: selected),
  );
  return result == null ? selected : result.value;
}

class _ChoiceResult {
  final String? value;

  const _ChoiceResult(this.value);
}

class _ChoiceSheet extends StatelessWidget {
  final String title;
  final List<ChoiceOption> options;
  final String? selected;

  const _ChoiceSheet({
    required this.title,
    required this.options,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    Widget tile(String? value, String label) {
      final isSelected = value == selected;
      return ListTile(
        onTap: () => Navigator.of(context).pop(_ChoiceResult(value)),
        title: Text(
          label,
          style: AppTextStyles.source.medium(
            fontSize: 15,
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyScale.grey900,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_rounded, color: AppColors.primaryColor)
            : null,
      );
    }

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(child: Text(title, style: CustomTextStyles.h3)),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 12),
              children: [
                tile(null, l.categoryAll),
                for (final option in options) tile(option.value, option.label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
