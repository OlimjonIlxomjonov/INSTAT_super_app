import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/other/basic_orientation_builder.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullscreen;
  final VoidCallback? onBack;
  final ValueNotifier<String>? currentResolutionNotifier;
  final ValueChanged<String>? onResolutionSelected;
  final ValueNotifier<bool>? isSwitchingResolutionNotifier;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    this.isFullscreen = false,
    this.onBack,
    this.currentResolutionNotifier,
    this.onResolutionSelected,
    this.isSwitchingResolutionNotifier,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  bool _everInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _everInitialized = _controller.value.isInitialized;
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Controller reference changed (resolution switch). Re-subscribe.
      oldWidget.controller.removeListener(_onControllerUpdate);
      _controller = widget.controller;
      if (_controller.value.isInitialized) _everInitialized = true;
      _controller.addListener(_onControllerUpdate);
    }
  }

  void _onControllerUpdate() {
    if (mounted && _controller.value.isInitialized) {
      _controller.removeListener(_onControllerUpdate);
      setState(() => _everInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_everInitialized) {
      return SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    return Container(
      alignment: Alignment.topCenter,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Positioned.fill(
            child: BasicOverlayWidget(
              controller: _controller,
              isFullscreen: widget.isFullscreen,
              onBack: widget.onBack,
              currentResolutionNotifier: widget.currentResolutionNotifier,
              onResolutionSelected: widget.onResolutionSelected,
              isSwitchingResolutionNotifier:
                  widget.isSwitchingResolutionNotifier,
            ),
          ),
        ],
      ),
    );
  }
}
