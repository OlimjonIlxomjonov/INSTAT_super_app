import 'package:flutter/material.dart';
import 'package:page_curl_effect/page_curl_effect.dart';

import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';

class BoughtBookOpenerWg extends StatefulWidget {
  const BoughtBookOpenerWg({super.key});

  @override
  State<BoughtBookOpenerWg> createState() => _BoughtBookOpenerWgState();
}

class _BoughtBookOpenerWgState extends State<BoughtBookOpenerWg> {
  late PageCurlController _controller;
  late Size _pageSize;

  final int _pageCount = 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final screen = MediaQuery.of(context).size;

    final width = screen.width;
    final height = screen.height;

    _pageSize = Size(width, height);

    _controller = PageCurlController(
      _pageSize,
      pageCurlIndex: 0,
      numberOfPage: _pageCount,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Center(
          child: PageCurlEffect(
            pageCurlController: _controller,
            pageBuilder: (context, index) {
              return SizedBox(
                width: _pageSize.width,
                height: _pageSize.height,
                child: PlaceHolderBookInner(index: index, pageSize: _pageSize),
              );
            },
            onForwardComplete: () {},
            onBackwardComplete: () {},
          ),
        ),
      ),
    );
  }
}

class PlaceHolderBookInner extends StatelessWidget {
  final int index;
  final Size pageSize;

  const PlaceHolderBookInner({
    super.key,
    required this.index,
    required this.pageSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Title $index',
                style: AppTextStyles.source.bold(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'Sub Title',
                style: AppTextStyles.source.semiBold(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: Text(
                      'lit, sed do eiusmod tempor lat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 200,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...',
              ),
              const SizedBox(height: 10),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...',
              ),

              SizedBox(height: pageSize.height * 0.12),
            ],
          ),
        ),
      ),
    );
  }
}
