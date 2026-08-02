import 'package:flutter/widgets.dart';

/// Fires [onLoadMore] once the user scrolls within [threshold] pixels of the
/// end of the wrapped scrollable.
///
/// Reusable for any paginated list — works for both vertical and horizontal
/// scrollables and needs no [ScrollController], so it can wrap an existing
/// list without restructuring it.
///
/// [onLoadMore] is intentionally allowed to fire repeatedly while the user
/// keeps scrolling near the end; de-duplicating is the bloc's job (ignore
/// the event while a page is already in flight or there are no more pages).
/// Guarding here instead would be fragile, because this widget can't know
/// when the request actually finishes.
class LoadMoreOnScroll extends StatelessWidget {
  const LoadMoreOnScroll({
    super.key,
    required this.onLoadMore,
    required this.canLoadMore,
    required this.child,
    this.threshold = 200,
  });

  /// Called when the end of the list is approaching.
  final VoidCallback onLoadMore;

  /// When false, no callbacks are fired at all (no more pages, or a page is
  /// already loading).
  final bool canLoadMore;

  /// Distance from the end, in pixels, at which to start loading.
  final double threshold;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (!canLoadMore) return false;

        // depth 0 == the scrollable this widget directly wraps. Guards
        // against a nested scrollable inside an item triggering paging.
        if (notification.depth != 0) return false;

        final metrics = notification.metrics;
        if (!metrics.hasContentDimensions) return false;

        if (metrics.pixels >= metrics.maxScrollExtent - threshold) {
          onLoadMore();
        }

        // false == keep the notification bubbling to any ancestor listeners.
        return false;
      },
      child: child,
    );
  }
}
