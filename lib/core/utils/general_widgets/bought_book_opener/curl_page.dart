import 'package:flutter/material.dart';
import 'package:my_template/core/utils/general_widgets/bought_book_opener/claude.dart';

class PageCurlView extends StatefulWidget {
  final List<Widget> pages;

  const PageCurlView({super.key, required this.pages});

  @override
  State<PageCurlView> createState() => _PageCurlViewState();
}

class _PageCurlViewState extends State<PageCurlView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double dragX = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragX -= details.delta.dx;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (dragX > 150 && currentPage < widget.pages.length - 1) {
      setState(() {
        currentPage++;
        dragX = 0;
      });
    } else {
      setState(() {
        dragX = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextPage = currentPage + 1 < widget.pages.length
        ? widget.pages[currentPage + 1]
        : null;

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              /// next page
              if (nextPage != null) nextPage,

              /// current page
              ClipPath(
                clipper: PageCurlClipper(dragX),
                child: widget.pages[currentPage],
              ),
            ],
          );
        },
      ),
    );
  }
}
