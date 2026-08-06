import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:video_player/video_player.dart';
import 'fullscreen_video_page.dart';

class BasicOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;
  final VoidCallback? onBack;
  final ValueNotifier<String>? currentResolutionNotifier;
  final ValueChanged<String>? onResolutionSelected;
  // Purely cosmetic: only ever read to decide whether to paint the small
  // spinner on top. Nothing else in this widget branches on it, so it can
  // never hide the back button / resolution menu / progress bar the way the
  // old switching-aware overlay logic used to.
  final ValueNotifier<bool>? isSwitchingResolutionNotifier;

  const BasicOverlayWidget({
    super.key,
    required this.controller,
    this.isFullscreen = false,
    this.onBack,
    this.currentResolutionNotifier,
    this.onResolutionSelected,
    this.isSwitchingResolutionNotifier,
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
  // stream) or starts buffering — a resolution switch never touches this
  // controller directly, so it never needs to know about that separately.
  void _playbackListener() {
    if (!mounted) return;
    final isBuffering = widget.controller.value.isBuffering;
    final isPlaying = widget.controller.value.isPlaying;
    if ((!isPlaying || isBuffering) && !_visibleNotifier.value) {
      _visibleNotifier.value = true;
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), _maybeHide);
  }

  void _maybeHide() {
    if (!mounted) return;
    if (widget.controller.value.isBuffering) {
      _hideTimer = Timer(const Duration(milliseconds: 500), _maybeHide);
      return;
    }
    if (widget.controller.value.isPlaying) {
      _visibleNotifier.value = false;
    }
  }

  void _toggleVisibility() {
    _visibleNotifier.value = !_visibleNotifier.value;
    if (_visibleNotifier.value && widget.controller.value.isPlaying) {
      _startHideTimer();
    }
  }

  void _seekBy(Duration offset) {
    final controller = widget.controller;
    final target = controller.value.position + offset;
    final duration = controller.value.duration;
    controller.seekTo(
      target < Duration.zero
          ? Duration.zero
          : (target > duration ? duration : target),
    );
    _startHideTimer();
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
            isSwitchingResolutionNotifier: widget.isSwitchingResolutionNotifier,
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
            // Never touched by resolution switching: that just swaps the
            // controller in the background once it's ready, so from this
            // widget's perspective nothing is happening while it loads.
            // ----------------------------------------------------------------
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _toggleVisibility,
              child: ValueListenableBuilder<bool>(
                valueListenable: _visibleNotifier,
                builder: (context, isVisible, _) {
                  final effectiveVisible = isVisible || isBuffering;
                  return AnimatedOpacity(
                    opacity: effectiveVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !effectiveVisible,
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
                                if (!widget.isFullscreen &&
                                    widget.currentResolutionNotifier != null &&
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

                          // 3. Center play/pause button
                          if (!isBuffering) _buildPlayPauseButton(),

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
                  final effectiveVisible = isVisible || isBuffering;
                  return AnimatedOpacity(
                    opacity: effectiveVisible ? 0.0 : 1.0,
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
            // Buffering / resolution-switch spinner — always on top, always
            // visible, but must never block taps to the controls underneath
            // (back, fullscreen, resolution, scrubbing). This is the ONLY
            // thing isSwitchingResolutionNotifier affects — it doesn't touch
            // opacity, the play/pause button, or the resolution menu, so a
            // switch can't hide anything else while it's in flight.
            // ----------------------------------------------------------------
            widget.isSwitchingResolutionNotifier != null
                ? ValueListenableBuilder<bool>(
                    valueListenable: widget.isSwitchingResolutionNotifier!,
                    builder: (context, isSwitching, _) =>
                        (isBuffering || isSwitching)
                        ? _buildLoadingOverlay()
                        : const SizedBox.shrink(),
                  )
                : (isBuffering
                      ? _buildLoadingOverlay()
                      : const SizedBox.shrink()),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  Widget _buildPlayPauseButton() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCircleButton(
            icon: Icons.replay_10_rounded,
            size: 30,
            onTap: () => _seekBy(const Duration(seconds: -10)),
          ),
          const SizedBox(width: 24),
          GestureDetector(
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
          const SizedBox(width: 24),
          _buildCircleButton(
            icon: Icons.forward_10_rounded,
            size: 30,
            onTap: () => _seekBy(const Duration(seconds: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }

  // Constrained to a small centered box (not a full-bleed Container) so the
  // spinner doesn't visually cover the back/fullscreen/scrubber controls
  // underneath — IgnorePointer only affects hit-testing, not painting.
  Widget _buildLoadingOverlay() {
    return const IgnorePointer(
      child: Center(
        child: SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

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
