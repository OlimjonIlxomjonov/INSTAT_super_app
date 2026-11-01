import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

enum TestQuestionStatus { unanswered, correct, wrong }

class TestQuestionNavigatorWg extends StatefulWidget {
  final int count;
  final int currentIndex;
  final TestQuestionStatus Function(int index) statusOf;
  final ValueChanged<int>? onSelect;

  const TestQuestionNavigatorWg({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.statusOf,
    this.onSelect,
  });

  @override
  State<TestQuestionNavigatorWg> createState() =>
      _TestQuestionNavigatorWgState();
}

class _TestQuestionNavigatorWgState extends State<TestQuestionNavigatorWg> {
  static const _itemSize = 40.0;
  static const _spacing = 8.0;
  static const _horizontalPadding = 20.0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  @override
  void didUpdateWidget(covariant TestQuestionNavigatorWg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) _scrollToCurrent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrent() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final itemStart =
        _horizontalPadding + widget.currentIndex * (_itemSize + _spacing);
    final target = itemStart - (position.viewportDimension - _itemSize) / 2;
    _scrollController.animateTo(
      target.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _itemSize + 4,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: 2,
        ),
        itemCount: widget.count,
        separatorBuilder: (_, _) => const SizedBox(width: _spacing),
        itemBuilder: (context, index) => _QuestionChip(
          number: index + 1,
          status: widget.statusOf(index),
          isCurrent: index == widget.currentIndex,
          onTap: widget.onSelect == null ? null : () => widget.onSelect!(index),
        ),
      ),
    );
  }
}

class _QuestionChip extends StatelessWidget {
  final int number;
  final TestQuestionStatus status;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _QuestionChip({
    required this.number,
    required this.status,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (status) {
      TestQuestionStatus.correct => (AppColors.green, AppColors.white),
      TestQuestionStatus.wrong => (AppColors.red, AppColors.white),
      TestQuestionStatus.unanswered when isCurrent => (
        AppColors.primaryColor.withValues(alpha: 0.1),
        AppColors.primaryColor,
      ),
      TestQuestionStatus.unanswered => (
        AppColors.greyScale.grey100,
        AppColors.greyScale.grey700,
      ),
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: isCurrent
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : null,
        ),
        child: Text(
          '$number',
          style: AppTextStyles.source.medium(fontSize: 15, color: foreground),
        ),
      ),
    );
  }
}
