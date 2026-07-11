// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:my_template/core/utils/app_utils.dart';
// import 'package:my_template/core/utils/constants/assets/app_animations.dart';
//
// OverlayEntry? _currentEntry;
//
// void errorFlushBar(BuildContext context, String message) {
//   _currentEntry?.remove();
//
//   final overlay = Overlay.of(context);
//   late OverlayEntry entry;
//
//   entry = OverlayEntry(
//     builder: (context) => _BlurTopBanner(
//       message: message,
//       onDismissed: () {
//         entry.remove();
//         if (_currentEntry == entry) _currentEntry = null;
//       },
//     ),
//   );
//
//   _currentEntry = entry;
//   overlay.insert(entry);
// }
//
// class _BlurTopBanner extends StatefulWidget {
//   final String message;
//   final VoidCallback onDismissed;
//
//   const _BlurTopBanner({required this.message, required this.onDismissed});
//
//   @override
//   State<_BlurTopBanner> createState() => _BlurTopBannerState();
// }
//
// class _BlurTopBannerState extends State<_BlurTopBanner>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 300),
//   );
//   late final Animation<Offset> _slide = Tween(
//     begin: const Offset(0, -1),
//     end: Offset.zero,
//   ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
//
//   @override
//   void initState() {
//     super.initState();
//     _controller.forward();
//     Future.delayed(const Duration(seconds: 3), _dismiss);
//   }
//
//   Future<void> _dismiss() async {
//     if (!mounted) return;
//     await _controller.reverse();
//     widget.onDismissed();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: MediaQuery.of(context).padding.top + 8,
//       left: 8,
//       right: 8,
//       child: SlideTransition(
//         position: _slide,
//         child: Material(
//           color: Colors.transparent,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.redFailedTaskCard.withValues(alpha: 0.4),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.only(
//                   left: 20,
//                   top: 10,
//                   bottom: 10,
//                   right: 10,
//                 ),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       width: 50,
//                       height: 50,
//                       child: Lottie.asset(
//                         AppAnimations.errorState,
//                         repeat: false,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         widget.message,
//                         style: AppTextStyles.source.semiBold(
//                           color: AppColors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
