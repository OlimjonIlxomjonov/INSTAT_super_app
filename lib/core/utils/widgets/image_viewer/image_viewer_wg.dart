import 'package:flutter/material.dart';

//! Telegram uslubidagi to'liq ekran
Future<void> showImageViewer(
  BuildContext context, {
  required ImageProvider image,
  required Object heroTag,
  ImageProvider? placeholder,
  VoidCallback? onOpenExternal,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, _, _) => ImageViewerPage(
        image: image,
        heroTag: heroTag,
        placeholder: placeholder,
        onOpenExternal: onOpenExternal,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class ImageViewerPage extends StatefulWidget {
  final ImageProvider image;
  final Object heroTag;

  //! To'liq rasm yuklanguncha ko'rinadigan kichik nusxa
  final ImageProvider? placeholder;
  final VoidCallback? onOpenExternal;

  const ImageViewerPage({
    super.key,
    required this.image,
    required this.heroTag,
    this.placeholder,
    this.onOpenExternal,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage>
    with SingleTickerProviderStateMixin {
  static const _dismissDistance = 120.0;
  static const _dismissVelocity = 700.0;
  static const _doubleTapScale = 2.5;

  final _transform = TransformationController();
  late final AnimationController _reset = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  Animation<Matrix4>? _zoomAnimation;
  TapDownDetails? _doubleTapDetails;
  double _dragOffset = 0;
  bool _chromeVisible = true;

  bool get _isZoomed => _transform.value.getMaxScaleOnAxis() > 1.01;

  @override
  void initState() {
    super.initState();
    _reset
      ..addListener(() {
        final zoom = _zoomAnimation;
        if (zoom != null) _transform.value = zoom.value;
      })
      ..addStatusListener((status) {
        //! Zoom holati o'zgardi — surib yopish yoqiladi/o'chiriladi
        if (status == AnimationStatus.completed && mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _reset.dispose();
    _transform.dispose();
    super.dispose();
  }

  void _animateTo(Matrix4 target) {
    _zoomAnimation = Matrix4Tween(
      begin: _transform.value,
      end: target,
    ).animate(CurvedAnimation(parent: _reset, curve: Curves.easeOut));
    _reset.forward(from: 0);
  }

  void _onDoubleTap() {
    if (_isZoomed) {
      _animateTo(Matrix4.identity());
      return;
    }
    final position = _doubleTapDetails?.localPosition ?? Offset.zero;
    _animateTo(
      Matrix4.identity()
        ..translateByDouble(
          -position.dx * (_doubleTapScale - 1),
          -position.dy * (_doubleTapScale - 1),
          0,
          1,
        )
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, 1, 1),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isZoomed) return;
    setState(() => _dragOffset += details.delta.dy);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isZoomed) return;
    final velocity = details.velocity.pixelsPerSecond.dy.abs();
    if (_dragOffset.abs() > _dismissDistance || velocity > _dismissVelocity) {
      Navigator.of(context).pop();
    } else {
      setState(() => _dragOffset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_dragOffset.abs() / 300).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 1 - progress * 0.8),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _chromeVisible = !_chromeVisible),
              onDoubleTapDown: (d) => _doubleTapDetails = d,
              onDoubleTap: _onDoubleTap,
              onVerticalDragUpdate: _isZoomed ? null : _onDragUpdate,
              onVerticalDragEnd: _isZoomed ? null : _onDragEnd,
              child: AnimatedContainer(
                duration: _dragOffset == 0
                    ? const Duration(milliseconds: 180)
                    : Duration.zero,
                transform: Matrix4.translationValues(0, _dragOffset, 0),
                child: InteractiveViewer(
                  transformationController: _transform,
                  minScale: 1,
                  maxScale: 5,
                  onInteractionEnd: (_) => setState(() {}),
                  child: Center(
                    child: Hero(
                      tag: widget.heroTag,
                      child: Image(
                        image: widget.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          final placeholder = widget.placeholder;
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              if (placeholder != null)
                                Image(image: placeholder, fit: BoxFit.contain),
                              const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ],
                          );
                        },
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          //! Yuqori panel
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _chromeVisible && _dragOffset == 0 ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                      const Spacer(),
                      if (widget.onOpenExternal != null)
                        IconButton(
                          onPressed: widget.onOpenExternal,
                          icon: const Icon(
                            Icons.ios_share_rounded,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
