import 'package:flutter/material.dart';

class DotSwitch extends StatelessWidget {
  const DotSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 52,
    this.height = 30,
    this.duration = const Duration(milliseconds: 180),
    this.activeTrackColor = const Color(0xFF2F80ED),
    this.inactiveTrackColor = const Color(0xFFE9EEF6),
    this.borderColor = const Color(0xFFCBD5E1),
    this.dotColor = const Color(0xFF1E5FD8),
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  final double width;
  final double height;
  final Duration duration;

  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color borderColor;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final trackRadius = height / 2;
    final thumbSize = height - 6;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: duration,
        width: width,
        height: height,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? activeTrackColor : inactiveTrackColor,
          borderRadius: BorderRadius.circular(trackRadius),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: AnimatedAlign(
          duration: duration,
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(0, 3),
                  color: Color(0x22000000),
                ),
              ],
            ),
            child: Center(
              child: AnimatedContainer(
                duration: duration,
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
