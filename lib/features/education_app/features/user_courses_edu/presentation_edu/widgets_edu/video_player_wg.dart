import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/other/basic_orientation_builder.dart';
import 'package:video_player/video_player.dart';

/// VideoPlayerWidget wraps a [VideoPlayerController] and renders the video
/// player together with its overlay controls.
///
/// Architecture notes:
/// • It is a [StatefulWidget] so it can safely add/remove a listener on the
///   controller when the widget is inserted/removed from the tree.
/// • All playback-driven rebuilds happen inside [BasicOverlayWidget] via
///   [AnimatedBuilder], so this widget itself only rebuilds when the
///   controller reference changes (e.g., during resolution switching).
class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    this.isFullscreen = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // We listen to the controller so we can rebuild ONLY when the initialized
  // state changes (first frame ready). After that, AnimatedBuilder in the
  // overlay drives all further updates.
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Controller reference changed (resolution switch). Re-subscribe.
      oldWidget.controller.removeListener(_onControllerUpdate);
      _controller = widget.controller;
      _controller.addListener(_onControllerUpdate);
    }
  }

  void _onControllerUpdate() {
    // Only trigger a rebuild of this widget when the initialized flag changes
    // (i.e., the first time the video is ready to display). All subsequent
    // playback position/state changes are handled locally inside
    // BasicOverlayWidget via AnimatedBuilder — this widget stays static.
    if (mounted && _controller.value.isInitialized) {
      // One-shot rebuild to switch from the loading indicator to the player.
      _controller.removeListener(_onControllerUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      alignment: Alignment.topCenter,
      child: Stack(
        children: <Widget>[
          // The raw VideoPlayer widget — renders frames, not rebuilt by Flutter
          // on every position change; the video_player plugin handles rendering.
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          // Overlay (controls + progress bar) handles its own rebuild cycle
          // via AnimatedBuilder keyed to the controller.
          Positioned.fill(
            child: BasicOverlayWidget(
              controller: _controller,
              isFullscreen: widget.isFullscreen,
            ),
          ),
        ],
      ),
    );
  }
}
