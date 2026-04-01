import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_files/course_files_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_files/course_files_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/regular_test/regular_test_course_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/video_player_wg.dart';
import 'package:video_player/video_player.dart';

class WatchCourseEduVideoPage extends StatefulWidget {
  final String title;
  final String? imagePath;
  final int courseId, topicId, lessonId;

  const WatchCourseEduVideoPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.courseId,
    required this.topicId,
    required this.lessonId,
  });

  @override
  State<WatchCourseEduVideoPage> createState() =>
      _WatchCourseEduVideoPageState();
}

class _WatchCourseEduVideoPageState extends State<WatchCourseEduVideoPage> {
  late VideoPlayerController controller;
  String currentResolution = '1080';

  @override
  void initState() {
    super.initState();
    context.read<CourseFilesBloc>().add(
      CourseFilesEvent(
        params: CourseFilesParams(
          courseId: widget.courseId,
          topicId: widget.topicId,
          lessonId: widget.lessonId,
        ),
      ),
    );
    _initVideo();
  }

  Future<void> changeResolution(String newRes) async {
    if (newRes == currentResolution) return;

    final currentPos = controller.value.position;
    final wasPlaying = controller.value.isPlaying;

    await controller.pause();
    setState(() {
      currentResolution = newRes;
    });

    final token = TokenStorageServiceImpl().getAccessToken();
    final url =
        'https://test.avacoder.uz/api/stream/${widget.lessonId}/${currentResolution}p.m3u8';

    final newController =
        VideoPlayerController.networkUrl(
            Uri.parse(url),
            httpHeaders: {"Authorization": "Bearer $token"},
            formatHint: VideoFormat.hls,
          )
          ..addListener(() => setState(() {}))
          ..setLooping(false);

    await newController.initialize();
    await newController.seekTo(currentPos);

    final oldController = controller;
    controller = newController;

    setState(() {});

    if (wasPlaying) {
      newController.play();
    }

    oldController.dispose();
  }

  Future<void> _initVideo() async {
    final token = TokenStorageServiceImpl().getAccessToken();

    if (token == null) {
      logger.e("No token found");
      return;
    }

    logger.f(token);
    final url =
        'https://test.avacoder.uz/api/stream/${widget.lessonId}/${currentResolution}p.m3u8';

    controller =
        VideoPlayerController.networkUrl(
            Uri.parse(url),
            httpHeaders: {"Authorization": "Bearer $token"},
            formatHint: VideoFormat.hls,
          )
          ..addListener(() => setState(() {}))
          ..setLooping(false);

    await controller.initialize();

    controller.play();

    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,

            /// VIDEO
            flexibleSpace: VideoPlayerWidget(controller: controller),
            leading: Padding(
              padding: .only(left: 10, top: 10),
              child: IconButton(
                onPressed: () {
                  FamilyNavigation.familyClose(context); // main
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                ),
                icon: const Icon(IconlyLight.arrow_left_2, size: 20),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                color: AppColors.white,
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.primaryColor,
                ),
                onSelected: changeResolution,
                itemBuilder: (context) => ['1080', '720', '480', '240']
                    .map(
                      (res) => PopupMenuItem(
                        value: res,
                        child: Text(
                          '${res}p${currentResolution == res ? ' (*)' : ''}',
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          SliverPadding(
            padding: AppPadding.horizontal20x(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyles.source.medium(fontSize: 20),
                  ),
                  Divider(color: AppColors.greyScale.grey200),

                  /// available files in the current course
                  SizedBox(height: appH(10)),
                  Text(
                    'Fayllar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  BlocBuilder<CourseFilesBloc, CourseFilesState>(
                    builder: (context, state) {
                      if (state is CourseFilesLoaded) {
                        final data = state.entity;

                        if (data.isEmpty) {
                          return Text(
                            'Hozirda kursga tegishli hech qanday fayylar mavjud emas!',
                            style: CustomTextStyles.h4,
                          );
                        }

                        return Column(
                          crossAxisAlignment: .start,
                          children: [
                            DefaultCustomTileWg(
                              tileMaxLines: 1,
                              tileOverflow: .ellipsis,
                              tileLeading: SvgPicture.asset(AppVectors.pdfIcon),
                              onTap: () {
                                controller.pause();
                              },
                              tileTitle: 'Tahlil, taqqoslash va prognozlash',
                              subTitle: '3.4 MB',
                            ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),

                  /// available tests in the current course
                  SizedBox(height: appH(10)),
                  Text(
                    'Test topshiriqlar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  DefaultCustomTileWg(
                    tileMaxLines: 1,
                    tileOverflow: .ellipsis,
                    tileLeading: SvgPicture.asset(AppVectors.pdfIcon),
                    onTap: () async {
                      controller.pause();
                      await openMiniAppSheetFamily(
                        context,
                        showHandler: false,
                        child: RegularTestCoursePage(),
                      );
                    },
                    tileTitle: 'Tahlil, taqqoslash va prognozlash',
                    subTitle: '3.4 MB',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
