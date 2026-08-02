import 'package:family_bottom_sheet/family_bottom_sheet.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/*
Yandex GO uslubidagi drag.

Muammo: header (SliverAppBar) CustomScrollView ichiga kirgach, barcha vertikal
drag'larni Scrollable gesture arena'da yutib oladi va bottom sheet'ning o'z
drag'i umuman ishlamay qoladi.

Yechim: header ustiga o'zimizning drag recognizer'imizni qo'yamiz. U arena'da
Scrollable'dan chuqurroq turgani uchun undan oldin qaror qabul qiladi, lekin
faqat ikkala shart bajarilgandagina drag'ni olib qoladi:
  1. scroll eng tepada turgan bo'lsa;
  2. barmoq PASTGA harakatlanayotgan bo'lsa.
Aks holda o'zini arenadan chiqaradi va drag odatdagidek Scrollable'ga o'tadi —
shuning uchun header'dan yuqoriga surish ro'yxatni normal scroll qilaveradi.

Drag boshlangach sheet'ning route animation controller'ini to'g'ridan-to'g'ri
suramiz. FamilyBottomSheet o'zining _handleDragUpdate'ida aynan shuni qiladi
(value -= delta / childHeight), FamilyModalSheetState.handleDragStart esa
animatsiya curve'ini linear'ga o'tkazadi — natijada sheet barmoqqa 1:1 ergashadi.
Qo'yib yuborilganda esa: tez pastga otilsa yoki yarmidan pastga tushgan bo'lsa
yopiladi, aks holda joyiga qaytadi.
*/

/// FamilyBottomSheet ichidagi scroll view'ning header'ini "ushlab tortiladigan"
/// zonaga aylantiradi.
class SheetDragAreaWg extends StatefulWidget {
  const SheetDragAreaWg({super.key, required this.child, this.sheetHeight});

  final Widget child;

  /// Sheet balandligi — harakat 1:1 bo'lishi uchun ishlatiladi.
  /// null bo'lsa ekran balandligi olinadi (mini app sheet'lari to'liq ekran).
  final double? sheetHeight;

  @override
  State<SheetDragAreaWg> createState() => _SheetDragAreaWgState();
}

/// Paketning FamilyBottomSheet'idagi qiymatlar bilan bir xil ushlab turilgan.
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

class _SheetDragAreaWgState extends State<SheetDragAreaWg> {
  FamilyModalSheetState? _sheet;
  ScrollableState? _scrollable;
  bool _dragging = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sheet = context.findAncestorStateOfType<FamilyModalSheetState>();
    _scrollable = Scrollable.maybeOf(context);
  }

  AnimationController? get _controller =>
      _sheet?.widget.route.animationController;

  double get _sheetHeight {
    final override = widget.sheetHeight;
    if (override != null && override > 0) return override;
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - mediaQuery.viewInsets.bottom;
  }

  /// Scroll eng tepada turibdimi — faqat shundagina drag sheet'ga tegishli.
  bool _canPull() {
    final position = _scrollable?.position;
    if (position == null || !position.hasPixels) return true;
    return position.pixels <= position.minScrollExtent + 1.0;
  }

  void _handleStart(DragStartDetails details) {
    final sheet = _sheet;
    if (sheet == null || _controller == null) return;
    _dragging = true;
    // Sheet barmoqqa aniq ergashishi uchun curve'ni linear'ga o'tkazadi.
    sheet.handleDragStart(details);
  }

  void _handleUpdate(DragUpdateDetails details) {
    final controller = _controller;
    if (!_dragging || controller == null) return;
    controller.value -= (details.primaryDelta ?? 0) / _sheetHeight;
  }

  void _handleEnd(DragEndDetails details) {
    final sheet = _sheet;
    final controller = _controller;
    if (!_dragging || sheet == null || controller == null) return;
    _dragging = false;

    // Joriy pozitsiyadan silliq davom etishi uchun Split curve o'rnatadi.
    sheet.handleDragEnd(details);

    final double velocity = details.primaryVelocity ?? 0; // > 0 => pastga
    final bool isClosing = velocity > _minFlingVelocity ||
        (velocity.abs() <= _minFlingVelocity &&
            controller.value < _closeProgressThreshold);

    if (!isClosing) {
      controller.forward();
      return;
    }

    if (sheet.canPopPage()) {
      // Ichki page yopiladi, sheet esa o'z joyiga ko'tariladi.
      sheet.popPage();
      controller.forward();
    } else {
      // Navigator.pop — route qolgan masofani o'zi animatsiya qilib tushiradi.
      sheet.popPage();
    }
  }

  void _handleCancel() {
    if (!_dragging) return;
    _dragging = false;
    _controller?.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Sheet ichida bo'lmasa (masalan desktop layout) — hech narsa o'zgarmaydi.
    if (_sheet == null) return widget.child;

    return RawGestureDetector(
      excludeFromSemantics: true,
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
        _SheetPullRecognizer:
            GestureRecognizerFactoryWithHandlers<_SheetPullRecognizer>(
              () => _SheetPullRecognizer(canPull: _canPull, debugOwner: this),
              (_SheetPullRecognizer instance) {
                instance
                  ..onStart = _handleStart
                  ..onUpdate = _handleUpdate
                  ..onEnd = _handleEnd
                  ..onCancel = _handleCancel
                  ..gestureSettings = MediaQuery.maybeGestureSettingsOf(context);
              },
            ),
      },
      child: widget.child,
    );
  }
}

/// Faqat pastga qaratilgan drag'ni oladi, qolganini Scrollable'ga qaytaradi.
class _SheetPullRecognizer extends VerticalDragGestureRecognizer {
  _SheetPullRecognizer({required this.canPull, super.debugOwner});

  final ValueGetter<bool> canPull;

  double _delta = 0;
  bool _decided = false;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _delta = 0;
    _decided = false;
    super.addAllowedPointer(event);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!_decided && event is PointerMoveEvent) {
      _delta += event.delta.dy;
      if (_delta.abs() >= computeHitSlop(event.kind, gestureSettings)) {
        _decided = true;
        if (_delta <= 0 || !canPull()) {
          // Yuqoriga surish yoki tepada emasmiz — drag Scrollable'niki.
          resolve(GestureDisposition.rejected);
          stopTrackingPointer(event.pointer);
          return;
        }
      }
    }
    super.handleEvent(event);
  }
}
