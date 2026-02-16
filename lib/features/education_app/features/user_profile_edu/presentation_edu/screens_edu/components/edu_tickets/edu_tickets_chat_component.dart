import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';

class EduTicketsChatComponent extends StatelessWidget {
  const EduTicketsChatComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Chat'),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(child: Column(children: [])),
          ),
        ],
      ),

      // bottomNavigationBar: SafeArea(
      //   child: Container(
      //     height: 50,
      //     margin: .symmetric(horizontal: 20, vertical: 10),
      //     child: TextField(
      //       maxLines: null,
      //       decoration: InputDecoration(
      //         prefixIcon: Column(
      //           mainAxisAlignment: .end,
      //           children: [
      //             IconButton(
      //               onPressed: () {},
      //               icon: Icon(Icons.attach_file, size: 25),
      //             ),
      //           ],
      //         ),
      //         hintText: 'message',
      //         suffixIcon: Column(
      //           mainAxisAlignment: .end,
      //           children: [
      //             IconButton(
      //               onPressed: () {},
      //               style: IconButton.styleFrom(),
      //               icon: Icon(IconlyBold.send, size: 30),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: .only(bottom: 5),
                child: Transform.rotate(
                  angle: 0.5,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file, size: 25),
                  ),
                ),
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 140),
                  child: Scrollbar(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: .circular(6),
                        color: AppColors.greyScale.grey50,
                      ),
                      child: TextField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: 'message',
                          suffixIcon: Column(
                            mainAxisAlignment: .end,
                            crossAxisAlignment: .end,
                            mainAxisSize: .min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  IconlyBold.send,
                                  size: 30,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Padding(
              //   padding: .only(bottom: 5),
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       IconlyBold.send,
              //       size: 30,
              //       color: AppColors.primaryColor,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
