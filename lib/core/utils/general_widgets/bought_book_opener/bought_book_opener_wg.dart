import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/common/params/online_books/online_books_params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/fetch_book_pages_count_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/fetch_book_pages_use_case.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/usecase/update_book_current_page_use_case.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

/// Opens a bought book for reading, page by page, using the real backend:
/// - GET books/{id}/pages-count/ once, to know total pages + where to resume
/// - GET books/{id}/pages/?page_number=N as needed, which returns a small
///   window {N-1, N, N+1} of {id, page_number} pairs
/// - GET book-pages/{id} for the actual page image (needs auth, unlike
///   plain /media/ files)
///
/// TurnPageView.builder (the page-curl package) builds every page widget
/// up front regardless of itemCount, so the only way to avoid fetching the
/// whole book's images at once is to make each page responsible for
/// deciding, on its own, whether it's currently close enough to the page
/// being read to bother loading anything at all.
class BoughtBookOpenerWg extends StatefulWidget {
  final int bookId;

  const BoughtBookOpenerWg({super.key, required this.bookId});

  @override
  State<BoughtBookOpenerWg> createState() => _BoughtBookOpenerWgState();
}

class _BoughtBookOpenerWgState extends State<BoughtBookOpenerWg> {
  final _fetchPagesCountUseCase = sl<FetchBookPagesCountUseCase>();
  final _fetchPagesUseCase = sl<FetchBookPagesUseCase>();
  final _updateCurrentPageUseCase = sl<UpdateBookCurrentPageUseCase>();

  bool _isLoading = true;
  bool _hasError = false;
  int _pagesCount = 0;

  late final TurnPageController _turnController;
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier(0);

  // page_number (1-based) -> book-page id. Shared across all page widgets
  // so flipping through pages already seen in a neighboring window is free.
  final Map<int, int> _pageIdCache = {};
  final Map<int, Future<int?>> _pageIdInFlight = {};

  // Debounced so rapidly flipping through several pages only reports
  // wherever the user actually settles, not every page passed through.
  Timer? _progressDebounce;

  // Immersive mode: the overlay (back/zoom/page count) shows briefly on
  // every page turn — so progress is visible right when it's useful — then
  // fades out. TurnPageView treats any tap as "turn the page," so there's
  // no safe tap zone left for a dedicated show/hide toggle; long-press is
  // used instead since it doesn't compete with TurnPageView's tap/drag
  // recognizers.
  bool _overlayVisible = true;
  Timer? _hideOverlayTimer;
  static const _overlayAutoHideDelay = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _progressDebounce?.cancel();
    _hideOverlayTimer?.cancel();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  void _showOverlayBriefly() {
    setState(() => _overlayVisible = true);
    _hideOverlayTimer?.cancel();
    _hideOverlayTimer = Timer(_overlayAutoHideDelay, () {
      if (mounted) setState(() => _overlayVisible = false);
    });
  }

  void _toggleOverlayManually() {
    if (_overlayVisible) {
      _hideOverlayTimer?.cancel();
      setState(() => _overlayVisible = false);
    } else {
      _showOverlayBriefly();
    }
  }

  Future<void> _load() async {
    try {
      final result = await _fetchPagesCountUseCase(widget.bookId);
      final initialIndex = result.pagesCount > 0
          ? (result.currentPage - 1).clamp(0, result.pagesCount - 1)
          : 0;
      _turnController = TurnPageController(initialPage: initialIndex);
      _currentIndexNotifier.value = initialIndex;
      if (!mounted) return;
      setState(() {
        _pagesCount = result.pagesCount;
        _isLoading = false;
      });
      _showOverlayBriefly();
    } catch (e) {
      logger.e(e);
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  /// Resolves the book-page id for [pageNumber], using the cache first.
  /// A single request also fills in the id for its neighbors, so this
  /// naturally gets cheaper the more of the book has already been visited.
  Future<int?> _resolvePageId(int pageNumber) {
    final cached = _pageIdCache[pageNumber];
    if (cached != null) return Future.value(cached);

    return _pageIdInFlight.putIfAbsent(pageNumber, () async {
      try {
        final pages = await _fetchPagesUseCase(
          BookPagesParams(bookId: widget.bookId, pageNumber: pageNumber),
        );
        for (final page in pages) {
          _pageIdCache[page.pageNumber] = page.id;
        }
        return _pageIdCache[pageNumber];
      } catch (e) {
        logger.e(e);
        return null;
      } finally {
        _pageIdInFlight.remove(pageNumber);
      }
    });
  }

  /// Opens the current page full-screen with pinch-to-zoom. Deliberately a
  /// separate screen rather than wrapping the page itself in an
  /// InteractiveViewer — TurnPageView already owns horizontal drag gestures
  /// for turning pages, and a pinch/pan zoom on the same surface would
  /// constantly compete with it for the gesture arena. Opening a dedicated
  /// view sidesteps that entirely.
  Future<void> _openZoom() async {
    final pageNumber = _currentIndexNotifier.value + 1;
    final id = await _resolvePageId(pageNumber);
    if (!mounted || id == null) return;

    final token = TokenStorageServiceImpl().getAccessToken();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _BookPageZoomView(
          imageUrl: ApiUrls.bookPageImageUrl(id),
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      ),
    );
  }

  void _onPageChanged() {
    final index = _turnController.currentIndex;
    _currentIndexNotifier.value = index;
    _showOverlayBriefly();

    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(milliseconds: 400), () {
      // Fire-and-forget — the use case itself swallows errors so a failed
      // report never disrupts reading.
      _updateCurrentPageUseCase(
        UpdateBookCurrentPageParams(
          bookId: widget.bookId,
          currentPage: index + 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || _pagesCount == 0) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => AppRoute.close(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const Center(child: Icon(Icons.error_outline, size: 48)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: _toggleOverlayManually,
        child: Stack(
          children: [
            TurnPageView.builder(
              controller: _turnController,
              animationTransitionPoint: .35,
              overleafColorBuilder: (index) => AppColors.greyScale.grey400,
              overleafBorderColorBuilder: (index) =>
                  AppColors.greyScale.grey700,
              overleafBorderWidthBuilder: (index) => 1,
              itemCount: _pagesCount,
              itemBuilder: (context, index) => _BookPageContent(
                pageNumber: index + 1,
                currentIndexListenable: _currentIndexNotifier,
                resolvePageId: _resolvePageId,
              ),
              onTap: (_) => _onPageChanged(),
              onSwipe: (_) => _onPageChanged(),
            ),
            IgnorePointer(
              ignoring: !_overlayVisible,
              child: AnimatedOpacity(
                opacity: _overlayVisible ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      left: 12,
                      child: IconButton(
                        onPressed: () => AppRoute.close(),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black38,
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 10,
                      right: 12,
                      child: IconButton(
                        onPressed: _openZoom,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black38,
                          shape: const CircleBorder(),
                        ),
                        icon: const Icon(Icons.zoom_in, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ValueListenableBuilder<int>(
                          valueListenable: _currentIndexNotifier,
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
                                    ? '$pageNumber / $_pagesCount  ·  $remaining left'
                                    : '$pageNumber / $_pagesCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
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
        ),
      ),
    );
  }
}

class _BookPageZoomView extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? headers;

  const _BookPageZoomView({required this.imageUrl, this.headers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: Image.network(
                imageUrl,
                headers: headers,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black38,
                shape: const CircleBorder(),
              ),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookPageContent extends StatefulWidget {
  final int pageNumber;
  final ValueListenable<int> currentIndexListenable;
  final Future<int?> Function(int pageNumber) resolvePageId;

  const _BookPageContent({
    required this.pageNumber,
    required this.currentIndexListenable,
    required this.resolvePageId,
  });

  @override
  State<_BookPageContent> createState() => _BookPageContentState();
}

class _BookPageContentState extends State<_BookPageContent> {
  // Pages within this many indices of the current one start loading their
  // image immediately, so by the time the user actually flips to them
  // they're already decoded and ready — this is what avoids visible lag.
  static const _preloadWindow = 1;

  bool _startedLoading = false;
  bool _failed = false;
  int? _pageId;

  @override
  void initState() {
    super.initState();
    widget.currentIndexListenable.addListener(_maybeStartLoading);
    _maybeStartLoading();
  }

  @override
  void dispose() {
    widget.currentIndexListenable.removeListener(_maybeStartLoading);
    super.dispose();
  }

  void _maybeStartLoading() {
    if (_startedLoading) return;
    final currentIndex = widget.currentIndexListenable.value;
    final distance = (widget.pageNumber - 1 - currentIndex).abs();
    if (distance <= _preloadWindow) {
      _startedLoading = true;
      _load();
    }
  }

  Future<void> _load() async {
    final id = await widget.resolvePageId(widget.pageNumber);
    if (!mounted) return;
    if (id == null) {
      setState(() => _failed = true);
    } else {
      setState(() => _pageId = id);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TurnPageAnimation (inside the package) wraps each page in Align,
    // which gives loose constraints — the curl/clip effect spans the full
    // page bounds regardless, but without forcing this content to expand
    // too, it would size itself to its own intrinsic size and just sit
    // centered inside that space instead of filling it, making BoxFit.cover
    // below a no-op.
    if (_failed) {
      return const SizedBox.expand(
        child: ColoredBox(
          color: Colors.white,
          child: Center(child: Icon(Icons.broken_image_outlined)),
        ),
      );
    }

    if (_pageId == null) {
      return const SizedBox.expand(
        child: ColoredBox(
          color: Colors.white,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }

    final token = TokenStorageServiceImpl().getAccessToken();
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.white,
        child: Image.network(
          ApiUrls.bookPageImageUrl(_pageId!),
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.broken_image_outlined)),
        ),
      ),
    );
  }
}
