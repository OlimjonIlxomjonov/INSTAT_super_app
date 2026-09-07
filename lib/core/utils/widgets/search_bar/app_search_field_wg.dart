import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';

/// Ichida yozish mumkin bo'lgan qidiruv maydoni.
/// [AppSearchbarWg] dan farqi — u faqat ko'rinish, bu esa haqiqiy input.
class AppSearchFieldWg extends StatefulWidget {
  const AppSearchFieldWg({
    super.key,
    required this.onChanged,
    this.hintText,
    this.autofocus = false,
    this.debounce = const Duration(milliseconds: 500),
  });

  final ValueChanged<String> onChanged;
  final String? hintText;
  final bool autofocus;
  final Duration debounce;

  @override
  State<AppSearchFieldWg> createState() => _AppSearchFieldWgState();
}

class _AppSearchFieldWgState extends State<AppSearchFieldWg> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, () => widget.onChanged(value.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.greyScale.grey200,
      ),
      child: Row(
        children: [
          Icon(IconlyLight.search, color: AppColors.greyScale.grey600),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                _debounce?.cancel();
                widget.onChanged(value.trim());
              },
              style: AppTextStyles.source.regular(fontSize: 14),
              decoration: InputDecoration(
                hintText: widget.hintText ?? localization.searchBooksHint,
                hintStyle: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  _debounce?.cancel();
                  _controller.clear();
                  widget.onChanged('');
                },
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.greyScale.grey600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
