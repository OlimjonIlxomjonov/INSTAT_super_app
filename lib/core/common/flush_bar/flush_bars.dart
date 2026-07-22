import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';

OverlayEntry? _currentEntry;

void errorFlushBar(BuildContext context, String message) {
  _showBlurBanner(
    context: context,
    message: message,
    color: AppColors.redFailedTaskCard,
    backgroundAlpha: 0.5,
    animationAsset: AppAnimations.errorState,
    duration: const Duration(seconds: 3),
    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 10),
  );
}

void successFlushBar(BuildContext context, String message) {
  _showBlurBanner(
    context: context,
    message: message,
    color: Colors.green,
    backgroundAlpha: 0.55,
    animationAsset: AppAnimations.successCheck,
    duration: const Duration(seconds: 3),
    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 10),
  );
}

void addedToCartFlushBar(BuildContext context, String message) {
  _showBlurBanner(
    context: context,
    message: message,
    color: AppColors.primaryColor,
    backgroundAlpha: 0.55,
    animationAsset: AppAnimations.addToCart,
    duration: const Duration(seconds: 2),
    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 10),
    // iconPadding: EdgeInsets.all(10),
  );
}

void technicalWorkFlushBar(BuildContext context, String message) {
  _showBlurBanner(
    context: context,
    message: message,
    color: AppColors.black,
    backgroundAlpha: 0.45,
    animationAsset: AppAnimations.workFuv,
    duration: const Duration(seconds: 3),
    padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 10),
  );
}

void _showBlurBanner({
  required BuildContext context,
  required String message,
  required Color color,
  required double backgroundAlpha,
  required String animationAsset,
  required Duration duration,
  required EdgeInsets padding,
  EdgeInsets iconPadding = EdgeInsets.zero,
}) {
  _currentEntry?.remove();

  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _BlurTopBanner(
      message: message,
      color: color,
      backgroundAlpha: backgroundAlpha,
      animationAsset: animationAsset,
      duration: duration,
      padding: padding,
      iconPadding: iconPadding,
      onDismissed: () {
        entry.remove();
        if (_currentEntry == entry) _currentEntry = null;
      },
    ),
  );

  _currentEntry = entry;
  overlay.insert(entry);
}

class _BlurTopBanner extends StatefulWidget {
  final String message;
  final Color color;
  final double backgroundAlpha;
  final String animationAsset;
  final Duration duration;
  final EdgeInsets padding;
  final EdgeInsets iconPadding;
  final VoidCallback onDismissed;

  const _BlurTopBanner({
    required this.message,
    required this.color,
    required this.backgroundAlpha,
    required this.animationAsset,
    required this.duration,
    required this.padding,
    required this.iconPadding,
    required this.onDismissed,
  });

  @override
  State<_BlurTopBanner> createState() => _BlurTopBannerState();
}

class _BlurTopBannerState extends State<_BlurTopBanner>
    with TickerProviderStateMixin {
  static const double _dismissDragDistance = 40;
  static const double _dismissFlingVelocity = -300;
  static const double _maxDragOffset = -300;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<Offset> _slide = Tween(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  Timer? _autoDismissTimer;
  AnimationController? _dragAnimController;
  bool _isDismissing = false;
  double _dragOffsetY = 0;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _scheduleAutoDismiss();
  }

  void _scheduleAutoDismiss() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    await _controller.reverse();
    if (mounted) widget.onDismissed();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_isDismissing) return;
    _autoDismissTimer?.cancel();
    setState(() {
      _dragOffsetY = (_dragOffsetY + details.primaryDelta!).clamp(
        _maxDragOffset,
        0.0,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_isDismissing) return;
    final flungUp = (details.primaryVelocity ?? 0) < _dismissFlingVelocity;
    final draggedFarEnough = _dragOffsetY < -_dismissDragDistance;

    if (flungUp || draggedFarEnough) {
      _dismissViaSwipe();
    } else {
      _snapBack();
    }
  }

  Future<void> _animateDragOffsetTo(double target, Duration duration) async {
    _dragAnimController?.dispose();
    final controller = AnimationController(vsync: this, duration: duration);
    _dragAnimController = controller;
    final animation = Tween<double>(
      begin: _dragOffsetY,
      end: target,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    animation.addListener(() {
      if (mounted) setState(() => _dragOffsetY = animation.value);
    });
    await controller.forward();
    controller.dispose();
    if (_dragAnimController == controller) _dragAnimController = null;
  }

  Future<void> _dismissViaSwipe() async {
    _isDismissing = true;
    await _animateDragOffsetTo(
      _maxDragOffset,
      const Duration(milliseconds: 200),
    );
    if (mounted) widget.onDismissed();
  }

  Future<void> _snapBack() async {
    await _animateDragOffsetTo(0, const Duration(milliseconds: 200));
    _scheduleAutoDismiss();
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _dragAnimController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 8,
      right: 8,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: SlideTransition(
          position: _slide,
          child: Transform.translate(
            offset: Offset(0, _dragOffsetY),
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color.withValues(
                        alpha: widget.backgroundAlpha,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: widget.padding,
                    child: Row(
                      children: [
                        Padding(
                          padding: widget.iconPadding,
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Lottie.asset(
                              widget.animationAsset,
                              repeat: false,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: AppTextStyles.source.semiBold(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
