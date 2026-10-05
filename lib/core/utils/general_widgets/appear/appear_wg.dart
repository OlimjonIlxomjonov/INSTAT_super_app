import 'dart:async';

import 'package:flutter/material.dart';

//! Ro'yxat chegarasi — har element bir marta o'ynaydi
class AppearScope extends StatefulWidget {
  final Widget child;

  const AppearScope({super.key, required this.child});

  @override
  State<AppearScope> createState() => _AppearScopeState();
}

class _AppearScopeState extends State<AppearScope> {
  static const _step = Duration(milliseconds: 45);
  static const _maxStagger = 8;
  static const _maxPerBatch = 12;

  final _seen = <Object>{};
  int _batch = 0;
  bool _resetScheduled = false;

  Duration? _claim(Object id) {
    if (!_seen.add(id)) return null;
    if (!_resetScheduled) {
      _resetScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _batch = 0;
        _resetScheduled = false;
      });
    }
    if (_batch >= _maxPerBatch) return null;
    final index = _batch++;
    return _step * (index < _maxStagger ? index : _maxStagger);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class AppearItem extends StatefulWidget {
  final Object id;
  final Widget child;

  const AppearItem({super.key, required this.id, required this.child});

  @override
  State<AppearItem> createState() => _AppearItemState();
}

class _AppearItemState extends State<AppearItem>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacity;
  Animation<Offset>? _offset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final delay = _resolveDelay();
    if (delay == null) return;

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    final curved = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    );
    _controller = controller;
    _opacity = curved;
    _offset = Tween(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(curved);

    if (delay == Duration.zero) {
      controller.forward();
    } else {
      _timer = Timer(delay, () {
        if (mounted) controller.forward();
      });
    }
  }

  Duration? _resolveDelay() {
    final scope = context.findAncestorStateOfType<_AppearScopeState>();
    if (scope == null) return null;
    final delay = scope._claim(widget.id);

    //! Reduce motion
    final reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;
    if (reduceMotion) return null;

    //! Scroll paytida emas
    final scrollable = context.findAncestorStateOfType<ScrollableState>();
    if (scrollable?.position.isScrollingNotifier.value ?? false) return null;

    return delay;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) return widget.child;
    return FadeTransition(
      opacity: _opacity!,
      child: SlideTransition(position: _offset!, child: widget.child),
    );
  }
}
