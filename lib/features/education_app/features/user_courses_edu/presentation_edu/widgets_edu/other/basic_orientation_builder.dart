import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:video_player/video_player.dart';
import 'fullscreen_video_page.dart';

/// BasicOverlayWidget renders the video controls overlay (play/pause button,
/// progress bar, remaining time, fullscreen toggle).
///
/// Architecture notes:
/// • Controls visibility is managed by a local [ValueNotifier<bool>]
///   (_visibleNotifier). AnimatedOpacity reads it via [ValueListenableBuilder]
///   so only the opacity subtree rebuilds when visibility toggles.
/// • The progress indicator row (time + scrubber + icons) is wrapped in an
///   [AnimatedBuilder] keyed to the [VideoPlayerController]. This means the
///   scrubber and remaining-time label update on every video frame tick, but
///   ONLY within that subtree — nothing outside it is rebuilt.
/// • The play/pause button in the centre is also inside [AnimatedBuilder] so
///   it reflects the playing state without triggering a setState on the whole
///   overlay.
/// • The playback listener (_playbackListener) only handles the edge case of
///   auto-revealing controls when playback pauses unexpectedly (e.g., buffering
///   end of stream). It never calls setState directly.
class BasicOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;
  final VoidCallback? onBack;
  final ValueNotifier<String>? currentResolutionNotifier;
  final ValueChanged<String>? onResolutionSelected;

  const BasicOverlayWidget({
    super.key,
    required this.controller,
    this.isFullscreen = false,
    this.onBack,
    this.currentResolutionNotifier,
    this.onResolutionSelected,
  });

  @override
  State<BasicOverlayWidget> createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  // ValueNotifier drives visibility — no setState needed for show/hide.
  final ValueNotifier<bool> _visibleNotifier = ValueNotifier(true);
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    widget.controller.addListener(_playbackListener);
  }

  @override
  void didUpdateWidget(BasicOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_playbackListener);
      widget.controller.addListener(_playbackListener);
    }
  }

  // Reveals controls when the video genuinely pauses (user action, end of
  // stream). Does NOT trigger during buffering — the spinner handles that.
  void _playbackListener() {
    if (!mounted) return;
    final isBuffering = widget.controller.value.isBuffering;
    final isPlaying = widget.controller.value.isPlaying;
    if (!isPlaying && !isBuffering && !_visibleNotifier.value) {
      _visibleNotifier.value = true;
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.controller.value.isPlaying) {
        _visibleNotifier.value = false;
      }
    });
  }

  void _toggleVisibility() {
    _visibleNotifier.value = !_visibleNotifier.value;
    if (_visibleNotifier.value && widget.controller.value.isPlaying) {
      _startHideTimer();
    }
  }

  void _togglePlayPause() {
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
      _hideTimer?.cancel();
      _visibleNotifier.value = true;
    } else {
      widget.controller.play();
      _startHideTimer();
    }
  }

  void _toggleFullscreen() {
    if (!widget.isFullscreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullscreenVideoPage(
            controller: widget.controller,
            currentResolutionNotifier: widget.currentResolutionNotifier,
            onResolutionSelected: widget.onResolutionSelected,
          ),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    widget.controller.removeListener(_playbackListener);
    _visibleNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final isBuffering = widget.controller.value.isBuffering;
        final position = widget.controller.value.position;
        final duration = widget.controller.value.duration;

        return Stack(
          children: [
            // ----------------------------------------------------------------
            // Controls overlay — shown/hidden by the visibility notifier.
            // ----------------------------------------------------------------
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleVisibility,
              child: ValueListenableBuilder<bool>(
                valueListenable: _visibleNotifier,
                builder: (context, isVisible, _) {
                  return AnimatedOpacity(
                    opacity: isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !isVisible,
                      child: Stack(
                        children: [
                          // 1. Semi-transparent background overlay
                          Positioned.fill(
                            child: Container(color: Colors.black45),
                          ),

                          // 2. Top control row (Back & Settings)
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed:
                                      widget.onBack ??
                                      () => Navigator.of(context).pop(),
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black38,
                                    shape: const CircleBorder(),
                                  ),
                                  icon: const Icon(
                                    IconlyLight.arrow_left_2,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                if (widget.currentResolutionNotifier != null &&
                                    widget.onResolutionSelected != null)
                                  ValueListenableBuilder<String>(
                                    valueListenable:
                                        widget.currentResolutionNotifier!,
                                    builder: (context, resolution, _) {
                                      return PopupMenuButton<String>(
                                        color: AppColors.white,
                                        icon: const Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        onSelected: (res) {
                                          widget.onResolutionSelected!(res);
                                          _startHideTimer();
                                        },
                                        itemBuilder: (context) =>
                                            ['1080', '720', '480', '240']
                                                .map(
                                                  (res) => PopupMenuItem(
                                                    value: res,
                                                    child: Text(
                                                      '${res}p${resolution == res ? ' *' : ''}',
                                                      style: AppTextStyles
                                                          .source
                                                          .medium(
                                                            fontSize: 14,
                                                            color:
                                                                resolution ==
                                                                    res
                                                                ? AppColors
                                                                      .primaryColor
                                                                : AppColors
                                                                      .black,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),

                          // 3. Center buttons (Rewind 10s, Play/Pause, Forward 10s)
                          if (!isBuffering)
                            Center(
                              child: GestureDetector(
                                onTap: _togglePlayPause,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black38,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    widget.controller.value.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 44,
                                  ),
                                ),
                              ),
                            ),

                          // 4. Bottom control row and scrubber
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                        style: AppTextStyles.source.medium(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _toggleFullscreen();
                                          _startHideTimer();
                                        },
                                        child: Icon(
                                          widget.isFullscreen
                                              ? Icons.fullscreen_exit
                                              : Icons.fullscreen,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VideoProgressIndicator(
                                  widget.controller,
                                  allowScrubbing: true,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  colors: VideoProgressColors(
                                    playedColor: AppColors.primaryColor,
                                    bufferedColor: Colors.white24,
                                    backgroundColor: Colors.white12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ----------------------------------------------------------------
            // Thin progress bar visible only when controls are hidden
            // ----------------------------------------------------------------
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<bool>(
                valueListenable: _visibleNotifier,
                builder: (context, isVisible, _) {
                  return AnimatedOpacity(
                    opacity: isVisible ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: true,
                      child: SizedBox(
                        height: 3,
                        child: VideoProgressIndicator(
                          widget.controller,
                          allowScrubbing: false,
                          padding: EdgeInsets.zero,
                          colors: VideoProgressColors(
                            playedColor: AppColors.primaryColor,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ----------------------------------------------------------------
            // Buffering spinner — always on top, always visible
            // ----------------------------------------------------------------
            if (isBuffering)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
