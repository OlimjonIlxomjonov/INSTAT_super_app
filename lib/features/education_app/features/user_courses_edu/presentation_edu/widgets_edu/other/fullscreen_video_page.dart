import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../video_player_wg.dart';

class FullscreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  final ValueNotifier<String>? currentResolutionNotifier;
  final ValueChanged<String>? onResolutionSelected;

  const FullscreenVideoPage({
    super.key,
    required this.controller,
    this.currentResolutionNotifier,
    this.onResolutionSelected,
  });

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscapeVideo = widget.controller.value.aspectRatio >= 1.0;

    // Force rotation ONLY if the video is wide but the phone is held in portrait
    final needsArtificialRotation = isLandscapeVideo && orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: needsArtificialRotation
            ? RotatedBox(
                quarterTurns: 1,
                child: VideoPlayerWidget(
                  controller: widget.controller,
                  isFullscreen: true,
                  currentResolutionNotifier: widget.currentResolutionNotifier,
                  onResolutionSelected: widget.onResolutionSelected,
                ),
              )
            : VideoPlayerWidget(
                controller: widget.controller,
                isFullscreen: true,
                currentResolutionNotifier: widget.currentResolutionNotifier,
                onResolutionSelected: widget.onResolutionSelected,
              ),
      ),
    );
  }
}
