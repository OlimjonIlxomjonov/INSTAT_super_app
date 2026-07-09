import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraController controller;

  const CameraPreviewWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late Offset _offset;
  bool _isExpanded = true;
  static const double _expandedWidth = 160;
  static const double _expandedHeight = 220;
  static const double _collapsedSize = 50;

  @override
  void initState() {
    super.initState();
    _offset = Offset(16, 80);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = _isExpanded ? _expandedWidth : _collapsedSize;
    final height = _isExpanded ? _expandedHeight : _collapsedSize;

    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          setState(() {
            final newX = (_offset.dx + details.delta.dx)
                .clamp(0.0, screenSize.width - width);
            final newY = (_offset.dy + details.delta.dy)
                .clamp(0.0, screenSize.height - height);
            _offset = Offset(newX, newY);
          });
        },
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(_isExpanded ? 12 : 25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_isExpanded ? 10 : 23),
            child: _isExpanded
                ? AspectRatio(
                    aspectRatio: 9 / 16,
                    child: CameraPreview(widget.controller),
                  )
                : Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
