import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_template/core/utils/constants/assets/app_vectors.dart';

//! Logo → ikonka matnni "yeydi" → markazda kattalashadi
class SplashLogoAnimation extends StatefulWidget {
  const SplashLogoAnimation({super.key});

  @override
  State<SplashLogoAnimation> createState() => _SplashLogoAnimationState();
}

class _SplashLogoAnimationState extends State<SplashLogoAnimation>
    with SingleTickerProviderStateMixin {
  //! SVG viewBox birliklari
  static const _w = 242.0;
  static const _h = 74.0;
  static const _iconRight = 91.0;
  static const _iconToCenter = _w / 2 - 45.5;
  static const _windUp = -14.0;
  static const _textShift = -90.0;
  static const _finalScale = 1.8;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();

  late final _fade = _interval(0, 0.18, Curves.easeOut);
  late final _appear = _interval(0, 0.24, Curves.easeOutBack);
  late final _wind = _interval(0.34, 0.44, Curves.easeOutCubic);
  late final _eat = _interval(0.44, 0.66, Curves.easeInOutCubic);
  late final _textGo = _interval(0.44, 0.64, Curves.easeInCubic);
  late final _zoom = _interval(0.62, 1, const ElasticOutCurve(0.7));

  late final Widget _icon = SvgPicture.asset(
    AppVectors.splashLogoIcon,
    width: _w,
    height: _h,
  );
  late final Widget _text = SvgPicture.asset(
    AppVectors.splashLogoText,
    width: _w,
    height: _h,
  );

  Animation<double> _interval(double begin, double end, Curve curve) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final iconDx = lerpDouble(
            _windUp * _wind.value,
            _iconToCenter,
            _eat.value,
          )!;
          final textDx = _textShift * _textGo.value;
          final iconScale = 1 + (_finalScale - 1) * _zoom.value;

          return Transform.scale(
            scale: 0.85 + 0.15 * _appear.value,
            child: SizedBox(
              width: _w,
              height: _h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRect(
                    clipper: _RightOf(_iconRight + iconDx),
                    child: Opacity(
                      opacity: 1 - _eat.value * _eat.value,
                      child: Transform.translate(
                        offset: Offset(textDx, 0),
                        child: _text,
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: iconScale,
                    child: Transform.translate(
                      offset: Offset(iconDx, 0),
                      child: _icon,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RightOf extends CustomClipper<Rect> {
  final double left;

  const _RightOf(this.left);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(left, -size.height, size.width * 2, size.height * 2);

  @override
  bool shouldReclip(_RightOf old) => old.left != left;
}
