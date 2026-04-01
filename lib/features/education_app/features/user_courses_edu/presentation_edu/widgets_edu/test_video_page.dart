import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TestVideoPage extends StatefulWidget {
  const TestVideoPage({super.key});

  @override
  State<TestVideoPage> createState() => _TestVideoPageState();
}

class _TestVideoPageState extends State<TestVideoPage> {
  VideoPlayerController? controller;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    controller = VideoPlayerController.networkUrl(
      Uri.parse("https://www.w3schools.com/html/mov_bbb.mp4"),
    );
    await controller!.initialize();
    setState(() {});
    controller!.play();
    controller!.addListener(() => setState(() {}));
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final position = controller!.value.position;
    final duration = controller!.value.duration;
    final isPlaying = controller!.value.isPlaying;
    final remaining = duration - position;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video
                VideoPlayer(controller!),

                // Controls overlay
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Center play/pause button
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.blue,
                              size: 32,
                            ),
                            onPressed: () {
                              isPlaying
                                  ? controller!.pause()
                                  : controller!.play();
                            },
                          ),
                        ),

                        // Bottom bar
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                // Small play/pause
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    isPlaying
                                        ? controller!.pause()
                                        : controller!.play();
                                  },
                                ),

                                // Progress bar
                                Expanded(
                                  child: VideoProgressIndicator(
                                    controller!,
                                    allowScrubbing: true,
                                    colors: const VideoProgressColors(
                                      playedColor: Colors.blue,
                                      bufferedColor: Colors.white38,
                                      backgroundColor: Colors.white24,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Remaining time
                                Text(
                                  '-${_formatDuration(remaining)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                // Fullscreen button
                                IconButton(
                                  icon: const Icon(
                                    Icons.fullscreen,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    // add fullscreen logic here
                                  },
                                ),
                              ],
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
        ),
      ),
    );
  }
}
