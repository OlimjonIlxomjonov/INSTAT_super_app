import 'dart:async';
import 'package:flutter/material.dart';
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

  const BasicOverlayWidget({
    super.key,
    required this.controller,
    this.isFullscreen = false,
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
    // No setState — AnimatedBuilder inside build() reacts to the controller.
  }

  void _toggleFullscreen() {
    if (!widget.isFullscreen) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              FullscreenVideoPage(controller: widget.controller),
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
    // AnimatedBuilder at the root level so isBuffering is always readable,
    // even when the controls overlay is invisible (hide-timer fired).
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final isBuffering = widget.controller.value.isBuffering;

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
                          // Play/pause button — hidden while buffering so the
                          // spinner is the sole centre element.
                          if (!isBuffering) _buildPlayButton(),
                          // Bottom control bar.
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _buildIndicator(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ----------------------------------------------------------------
            // Buffering spinner — always on top, always visible regardless of
            // whether the controls are currently shown or hidden.
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
  // Indicator bar (progress + time + fullscreen)
  // ---------------------------------------------------------------------------
  Widget _buildIndicator() {
    final position = widget.controller.value.position;
    final duration = widget.controller.value.duration;
    final remaining = duration - position;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              GestureDetector(
                onTap: _togglePlayPause,
                child: Icon(
                  widget.controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: VideoProgressIndicator(
                    padding: EdgeInsets.zero,
                    widget.controller,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '-${_formatDuration(remaining)}',
                style: AppTextStyles.source.medium(
                  fontSize: 14,
                  color: AppColors.greyScale.grey400,
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: _toggleFullscreen,
                child: Icon(
                  widget.isFullscreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Centre play/pause button
  // ---------------------------------------------------------------------------
  Widget _buildPlayButton() {
    return Container(
      alignment: Alignment.center,
      color: Colors.black26,
      child: GestureDetector(
        onTap: _togglePlayPause,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              widget.controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: AppColors.primaryColor,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
