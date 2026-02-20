// import 'package:flutter/material.dart';
// import 'package:turnable_page/turnable_page.dart';
//
// class MyBook extends StatefulWidget {
//   @override
//   State<MyBook> createState() => _MyBookState();
// }
//
// class _MyBookState extends State<MyBook> {
//   bool isVerticalFlip = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 isVerticalFlip = !isVerticalFlip;
//               });
//             },
//             icon: Icon(
//               isVerticalFlip ? Icons.arrow_left : Icons.arrow_drop_down,
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: TurnablePage(
//           pageCount: 6,
//           settings: FlipSettings(
//             maxShadowOpacity: 0.2,
//             onlyVerticalPageFlip: isVerticalFlip,
//           ),
//           builder: (context, index, constraints) {
//             return Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Center(
//                 child: Text(
//                   'Page ${index + 1}',
//                   style: TextStyle(fontSize: 24),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
