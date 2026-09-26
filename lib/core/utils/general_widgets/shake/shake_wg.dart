import 'package:flutter/material.dart';

/// [shake] `false` dan `true` ga o'tganda bolani chapga-o'ngga silkitadi.
class ShakeWg extends StatefulWidget {
  final bool shake;
  final Widget child;

  const ShakeWg({super.key, required this.shake, required this.child});

  @override
  State<ShakeWg> createState() => _ShakeWgState();
}

class _ShakeWgState extends State<ShakeWg> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  late final Animation<double> _offset = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 10), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -10, end: 7), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 7, end: -5), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -5, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    if (widget.shake) _controller.forward(from: 0);
  }

  @override
  void didUpdateWidget(ShakeWg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      builder: (context, child) =>
          Transform.translate(offset: Offset(_offset.value, 0), child: child),
      child: widget.child,
    );
  }
}
