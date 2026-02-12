// import 'package:flutter/material.dart';
// import 'package:iconly/iconly.dart';
// import 'package:my_template/core/utils/constants/colors/app_colors.dart';
// import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
// import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
//
// class MinimalCoursesCardWg extends StatelessWidget {
//   const MinimalCoursesCardWg({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: .only(bottom: appH(20)),
//       padding: .all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.greyScale.grey200),
//         borderRadius: .circular(16),
//       ),
//       child: Row(
//         spacing: appW(10),
//         crossAxisAlignment: .start,
//         children: [
//           ClipRRect(
//             borderRadius: .circular(12),
//             child: Image.asset(
//               width: appW(93),
//               height: appH(75),
//               'assets/home_page/temp_course_card_popular.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: .start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         "Uy xo’jaliklarini tanlanma kuzatuvini tashkil etish va o’tkazish",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextStyles.source.medium(fontSize: 15),
//                       ),
//                     ),
//                     SizedBox(width: appW(8)),
//                     // IconButton(
//                     //   padding: EdgeInsets.zero,
//                     //   onPressed: () {},
//                     //   icon: Icon(IconlyLight.heart, size: 20),
//                     //   // style: IconButton.styleFrom(
//                     //   //   shape: RoundedRectangleBorder(
//                     //   //     borderRadius: BorderRadius.circular(6),
//                     //   //     side: BorderSide(
//                     //   //       color: AppColors.greyScale.grey200,
//                     //   //     ),
//                     //   //   ),
//                     //   // ),
//                     // ),
//                   ],
//                 ),
//                 Text(
//                   'Kategoriya nomi',
//                   style: AppTextStyles.source.medium(
//                     fontSize: 12,
//                     color: AppColors.greyScale.grey600,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: AppColors.orange, size: 18),
//                     Flexible(
//                       child: Text(
//                         ' 4,5 (832)',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: AppTextStyles.source.regular(fontSize: 13),
//                       ),
//                     ),
//                     SizedBox(width: appW(8)),
//                     Icon(IconlyLight.document, size: 18),
//                     Text(
//                       ' 12 ta',
//                       style: AppTextStyles.source.regular(fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
