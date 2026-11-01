import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_realistic_flipbook/flutter_realistic_flipbook.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/bought_book_opener/book_page_loader.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/fetch_book_pages_count_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/fetch_book_pages_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/update_book_current_page_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_book_bloc.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/bloc/user_books/user_books_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _PageStatus { loading, ready, failed }

class BoughtBookOpenerWg extends StatefulWidget {
  final int bookId;

  const BoughtBookOpenerWg({super.key, required this.bookId});

  @override
  State<BoughtBookOpenerWg> createState() => _BoughtBookOpenerWgState();
}

class _BoughtBookOpenerWgState extends State<BoughtBookOpenerWg>
    with SingleTickerProviderStateMixin {
  static const _fitContentKey = 'book_reader_fit_content';
  static const _overlayAutoHideDelay = Duration(seconds: 3);
  static const _doubleTapTimeout = Duration(milliseconds: 260);
  static const _doubleTapScale = 2.5;
  static const _sideTapZone = 0.28;

  final _fetchPagesCountUseCase = sl<FetchBookPagesCountUseCase>();
  final _updateCurrentPageUseCase = sl<UpdateBookCurrentPageUseCase>();
  final _flipbook = FlipbookController();
  final _transform = TransformationController();
  final _currentIndex = ValueNotifier<int>(0);
  late final AnimationController _zoomAnimation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  Animation<Matrix4>? _zoomTween;

  BookPageLoader? _loader;
  int _pagesCount = 0;
  int _startPage = 1;
  bool _isLoading = true;
  bool _hasError = false;
  bool _fitContent = true;
  bool _isZoomed = false;
  bool _overlayVisible = true;
  bool _finalized = false;

  List<FlipbookPage?> _pages = const [];
  Object? _pagesSignature;
  final Map<int, int> _pageGenerations = {};
  int _generationVersion = 0;

  _PageStatus _pageStatus = _PageStatus.loading;
  ImageStream? _watchedStream;
  ImageStreamListener? _watchedListener;

  Timer? _hideOverlayTimer;
  Timer? _overlayTapTimer;
  Timer? _progressDebounce;
  DateTime? _lastTapAt;
  Offset? _lastTapPosition;

  @override
  void initState() {
    super.initState();
    _zoomAnimation
      ..addListener(() {
        final tween = _zoomTween;
        if (tween != null) _transform.value = tween.value;
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) _syncZoom();
      });
    _restoreFitContent();
    _load();
  }

  @override
  void dispose() {
    _finalizeProgress();
    _unwatchCurrentPage();
    _hideOverlayTimer?.cancel();
    _overlayTapTimer?.cancel();
    _progressDebounce?.cancel();
    _loader?.dispose();
    _zoomAnimation.dispose();
    _transform.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  Future<void> _restoreFitContent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_fitContentKey);
      if (saved != null && mounted) setState(() => _fitContent = saved);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _toggleFitContent() async {
    setState(() => _fitContent = !_fitContent);
    _showOverlayBriefly();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_fitContentKey, _fitContent);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _fetchPagesCountUseCase(widget.bookId);
      if (!mounted) return;

      final count = result.pagesCount;
      final initial = count > 0
          ? (result.currentPage - 1).clamp(0, count - 1)
          : 0;
      _loader?.dispose();
      _currentIndex.value = initial;
      setState(() {
        _loader = BookPageLoader(
          bookId: widget.bookId,
          fetchPages: sl<FetchBookPagesUseCase>(),
        );
        _pagesCount = count;
        _startPage = initial + 1;
        _pagesSignature = null;
        _isLoading = false;
        _hasError = count == 0;
      });
      _showOverlayBriefly();
    } catch (e) {
      logger.e(e);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  void _finalizeProgress() {
    if (_finalized || _pagesCount == 0) return;
    _finalized = true;
    _progressDebounce?.cancel();

    final lastPage = _currentIndex.value + 1;
    _updateCurrentPageUseCase(
      UpdateBookCurrentPageParams(bookId: widget.bookId, currentPage: lastPage),
    ).whenComplete(() => sl<UserBookBloc>().add(const RefreshUserBooksEvent()));
  }

  void _closeReader() {
    _finalizeProgress();
    AppRoute.close();
  }

  List<FlipbookPage?> _pagesFor(
    BookPageLoader loader,
    Size size,
    double pixelRatio,
    EdgeInsets padding,
  ) {
    final pixelSize = Size(
      (size.width * pixelRatio).roundToDouble(),
      (size.height * pixelRatio).roundToDouble(),
    );
    final pixelPadding = padding * pixelRatio;
    final signature = (
      pixelSize,
      pixelPadding,
      _fitContent,
      _generationVersion,
    );
    if (signature == _pagesSignature) return _pages;

    if (_pagesSignature != null) _startPage = _currentIndex.value + 1;
    _pagesSignature = signature;
    _pages = List<FlipbookPage?>.generate(
      _pagesCount,
      (index) => FlipbookPage(
        image: BookPageImage(
          loader: loader,
          pageNumber: index + 1,
          fitContent: _fitContent,
          pixelSize: pixelSize,
          pixelPadding: pixelPadding,
          generation: _pageGenerations[index + 1] ?? 0,
        ),
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _watchCurrentPage());
    return _pages;
  }

  void _watchCurrentPage() {
    if (!mounted) return;
    final index = _currentIndex.value;
    if (index < 0 || index >= _pages.length) return;
    final provider = _pages[index]?.image;
    if (provider == null) return;

    _unwatchCurrentPage();
    setState(() => _pageStatus = _PageStatus.loading);

    final stream = provider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener(
      (info, _) {
        info.dispose();
        _setPageStatus(index, _PageStatus.ready);
      },
      onError: (error, stackTrace) {
        logger.e(error);
        _setPageStatus(index, _PageStatus.failed);
      },
    );
    _watchedStream = stream;
    _watchedListener = listener;
    stream.addListener(listener);
  }

  void _unwatchCurrentPage() {
    final stream = _watchedStream;
    final listener = _watchedListener;
    if (stream != null && listener != null) stream.removeListener(listener);
    _watchedStream = null;
    _watchedListener = null;
  }

  void _setPageStatus(int index, _PageStatus status) {
    if (!mounted || index != _currentIndex.value || _pageStatus == status) {
      return;
    }
    setState(() => _pageStatus = status);
  }

  void _retryCurrentPage() {
    final page = _currentIndex.value + 1;
    _pageGenerations[page] = (_pageGenerations[page] ?? 0) + 1;
    setState(() => _generationVersion++);
  }

  void _onFlipEnd(int page) {
    final index = (page - 1).clamp(0, _pagesCount - 1);
    if (index == _currentIndex.value) return;
    _currentIndex.value = index;
    _watchCurrentPage();

    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(milliseconds: 400), () {
      _updateCurrentPageUseCase(
        UpdateBookCurrentPageParams(
          bookId: widget.bookId,
          currentPage: index + 1,
        ),
      );
    });
  }

  void _showOverlayBriefly() {
    if (!_overlayVisible) setState(() => _overlayVisible = true);
    _hideOverlayTimer?.cancel();
    _hideOverlayTimer = Timer(_overlayAutoHideDelay, () {
      if (mounted) setState(() => _overlayVisible = false);
    });
  }

  void _toggleOverlay() {
    if (_overlayVisible) {
      _hideOverlayTimer?.cancel();
      setState(() => _overlayVisible = false);
    } else {
      _showOverlayBriefly();
    }
  }

  void _onTapUp(TapUpDetails details) {
    final position = details.localPosition;
    final width = MediaQuery.sizeOf(context).width;
    final now = DateTime.now();
    final lastTapAt = _lastTapAt;
    final lastTapPosition = _lastTapPosition;
    final isDoubleTap =
        lastTapAt != null &&
        lastTapPosition != null &&
        now.difference(lastTapAt) < _doubleTapTimeout &&
        (position - lastTapPosition).distance < 48;

    if (isDoubleTap) {
      _overlayTapTimer?.cancel();
      _lastTapAt = null;
      _toggleZoom(position);
      return;
    }

    if (!_isZoomed) {
      if (position.dx < width * _sideTapZone) {
        _flipbook.flipLeft();
        return;
      }
      if (position.dx > width * (1 - _sideTapZone)) {
        _flipbook.flipRight();
        return;
      }
    }

    _lastTapAt = now;
    _lastTapPosition = position;
    _overlayTapTimer?.cancel();
    _overlayTapTimer = Timer(_doubleTapTimeout, _toggleOverlay);
  }

  void _toggleZoom(Offset focal) {
    final target = _isZoomed
        ? Matrix4.identity()
        : (Matrix4.identity()
            ..translateByDouble(
              -focal.dx * (_doubleTapScale - 1),
              -focal.dy * (_doubleTapScale - 1),
              0,
              1,
            )
            ..scaleByDouble(_doubleTapScale, _doubleTapScale, 1, 1));
    _zoomTween = Matrix4Tween(
      begin: _transform.value,
      end: target,
    ).animate(CurvedAnimation(parent: _zoomAnimation, curve: Curves.easeOut));
    _zoomAnimation.forward(from: 0);
  }

  void _syncZoom() {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _isZoomed && mounted) setState(() => _isZoomed = zoomed);
  }

  @override
  Widget build(BuildContext context) {
    final loader = _loader;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: TDeviceUtils.darkStatusBarIcons,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: _isLoading
            ? _ReaderStatus(
                onBack: _closeReader,
                child: const CircularProgressIndicator(),
              )
            : (_hasError || loader == null)
            ? _ReaderStatus(
                onBack: _closeReader,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SectionErrorWg(onRetry: _load),
                ),
              )
            : _buildReader(context, loader),
      ),
    );
  }

  Widget _buildReader(BuildContext context, BookPageLoader loader) {
    final localization = AppLocalizations.of(context)!;
    final safe = MediaQuery.paddingOf(context);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final pagePadding = EdgeInsets.fromLTRB(
      8,
      safe.top + 8,
      8,
      safe.bottom + 28,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: _onTapUp,
          child: InteractiveViewer(
            transformationController: _transform,
            minScale: 1,
            maxScale: 4,
            panEnabled: _isZoomed,
            onInteractionStart: (_) => _zoomAnimation.stop(),
            onInteractionEnd: (_) => _syncZoom(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pages = _pagesFor(
                  loader,
                  constraints.biggest,
                  pixelRatio,
                  pagePadding,
                );
                return IgnorePointer(
                  ignoring: _isZoomed,
                  child: RealisticFlipbook(
                    controller: _flipbook,
                    pages: pages,
                    startPage: _startPage,
                    singlePage: true,
                    singlePageSpreadNavigation: false,
                    tapToFlip: false,
                    clickToZoom: false,
                    dragToScroll: false,
                    flipDuration: const Duration(milliseconds: 850),
                    paperColor: AppColors.white,
                    blankPageColor: AppColors.white,
                    loadingBuilder: (_) => const SizedBox.shrink(),
                    onFlipLeftEnd: _onFlipEnd,
                    onFlipRightEnd: _onFlipEnd,
                  ),
                );
              },
            ),
          ),
        ),
        if (_pageStatus == _PageStatus.loading)
          const IgnorePointer(
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_pageStatus == _PageStatus.failed)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: 40,
                  color: AppColors.greyScale.grey400,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _retryCurrentPage,
                  child: Text(
                    localization.retry,
                    style: AppTextStyles.source.medium(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: safe.bottom + 6,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _overlayVisible ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, index, _) => Text(
                  '${index + 1} / $_pagesCount',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey500,
                  ),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: !_overlayVisible,
          child: AnimatedOpacity(
            opacity: _overlayVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              children: [
                Positioned(
                  top: safe.top + 8,
                  left: 12,
                  child: _OverlayButton(
                    icon: Icons.arrow_back,
                    onPressed: _closeReader,
                  ),
                ),
                Positioned(
                  top: safe.top + 8,
                  right: 12,
                  child: _OverlayButton(
                    icon: Icons.crop,
                    tooltip: localization.bookTrimMargins,
                    isActive: _fitContent,
                    onPressed: _toggleFitContent,
                  ),
                ),
                Positioned(
                  bottom: safe.bottom + 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentIndex,
                      builder: (context, index, _) {
                        final pageNumber = index + 1;
                        final remaining = _pagesCount - pageNumber;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            remaining > 0
                                ? '$pageNumber / $_pagesCount  ·  ${localization.bookPagesLeft(remaining)}'
                                : '$pageNumber / $_pagesCount',
                            style: AppTextStyles.source.regular(
                              fontSize: 13,
                              color: AppColors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OverlayButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool isActive;

  const _OverlayButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: isActive ? AppColors.primaryColor : Colors.black38,
        shape: const CircleBorder(),
      ),
      icon: Icon(icon, color: AppColors.white),
    );
  }
}

class _ReaderStatus extends StatelessWidget {
  final VoidCallback onBack;
  final Widget child;

  const _ReaderStatus({required this.onBack, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: child),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 12,
          child: _OverlayButton(icon: Icons.arrow_back, onPressed: onBack),
        ),
      ],
    );
  }
}
