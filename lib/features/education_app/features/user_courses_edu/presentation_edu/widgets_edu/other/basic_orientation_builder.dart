import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:video_player/video_player.dart';
import 'fullscreen_video_page.dart';

class BasicOverlayWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const BasicOverlayWidget({super.key, required this.controller});

  @override
  State<BasicOverlayWidget> createState() => _BasicOverlayWidgetState();
}

class _BasicOverlayWidgetState extends State<BasicOverlayWidget> {
  bool _isVisible = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
    widget.controller.addListener(_playbackListener);
  }

  void _playbackListener() {
    if (!mounted) return;
    if (!widget.controller.value.isPlaying && !_isVisible) {
      setState(() => _isVisible = true);
      _hideTimer?.cancel();
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.controller.value.isPlaying) {
        setState(() => _isVisible = false);
      }
    });
  }

  void _toggleVisibility() {
    setState(() => _isVisible = !_isVisible);
    if (_isVisible && widget.controller.value.isPlaying) {
      _startHideTimer();
    }
  }

  void _togglePlayPause() {
    widget.controller.value.isPlaying
        ? widget.controller.pause()
        : widget.controller.play();
    setState(() {});
    
    if (widget.controller.value.isPlaying) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
      setState(() => _isVisible = true);
    }
  }
  
  void _toggleFullscreen() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if (isPortrait) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullscreenVideoPage(controller: widget.controller),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleVisibility,
      child: Stack(
        children: <Widget>[
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !_isVisible,
              child: Stack(
                children: [
                   buildPlay(),
                   Positioned(bottom: 0, left: 0, right: 0, child: buildIndicator()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    final position = widget.controller.value.position;
    final duration = widget.controller.value.duration;
    final remaining = duration - position;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

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
                  widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
                  isPortrait ? Icons.fullscreen : Icons.fullscreen_exit,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget buildPlay() => widget.controller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: GestureDetector(
            onTap: _togglePlayPause,
            child: DecoratedBox(
              decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.play_arrow, color: AppColors.primaryColor, size: 40),
              ),
            ),
          ),
        );
}
