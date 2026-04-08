import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
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
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/video_thumbnail_wg.dart';

class WatchCourseEduVideoPage extends StatefulWidget {
  final String title;
  final String? imagePath;
  final int courseId, topicId, lessonId;
  final int? testCount;

  const WatchCourseEduVideoPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.courseId,
    required this.topicId,
    required this.lessonId,
    required this.testCount,
  });

  @override
  State<WatchCourseEduVideoPage> createState() =>
      _WatchCourseEduVideoPageState();
}

class _WatchCourseEduVideoPageState extends State<WatchCourseEduVideoPage> {
  VideoPlayerController? controller;
  String currentResolution = '1080';
  bool _isDownloading = false;
  bool _showVideo = false;

  Future<void> _openFile(String? url, String? fileName) async {
    if (url == null || url.isEmpty || fileName == null || fileName.isEmpty) {
      errorFlushBar(context, 'Fayl manzili topilmadi');
      return;
    }

    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final savePath = '${tempDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, savePath);

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && mounted) {
        errorFlushBar(
          context,
          'Faylni ochishda xatolik yuz berdi. ${result.message}',
        );
      }
    } catch (e) {
      if (mounted) {
        errorFlushBar(context, 'Faylni yuklab olishda xatolik yuz berdi.');
      }
      logger.e(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

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
    // _initVideo(); // Do NOT initialize here to save resources and prevent emulator crashes on load. We load lazily on tap!
  }

  Future<void> changeResolution(String newRes) async {
    if (newRes == currentResolution || controller == null) return;

    final currentPos = controller!.value.position;
    final wasPlaying = controller!.value.isPlaying;

    await controller!.pause();
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

    oldController?.dispose();
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

    controller?.dispose();
    controller =
        VideoPlayerController.networkUrl(
            Uri.parse(url),
            httpHeaders: {"Authorization": "Bearer $token"},
            formatHint: VideoFormat.hls,
          )
          ..addListener(() => setState(() {}))
          ..setLooping(false);

    await controller!.initialize();

    controller!.play();

    setState(() {});
  }

  @override
  void dispose() {
    controller?.pause();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            collapsedHeight: 250,
            pinned: true,

            /// VIDEO
            flexibleSpace: FlexibleSpaceBar(
              background: _showVideo
                  ? (controller != null
                        ? VideoPlayerWidget(controller: controller!)
                        : const Center(child: CircularProgressIndicator()))
                  : VideoThumbnailWidget(
                      imagePath: widget.imagePath,
                      onTap: () {
                        setState(() {
                          _showVideo = true;
                        });
                        _initVideo();
                      },
                    ),
            ),
            leading: Padding(
              padding: .only(left: 10, top: 10),
              child: IconButton(
                onPressed: () {
                  controller?.pause();
                  FamilyNavigation.familyClose(context); // main
                },
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.white.withValues(alpha: 0.6),
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                ),
                icon: Icon(IconlyLight.arrow_left_2, size: 20),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                color: AppColors.white,
                icon: Icon(
                  Icons.settings,
                  color: AppColors.greyScale.grey600,
                  size: 28,
                ),
                onSelected: changeResolution,
                itemBuilder: (context) => ['1080', '720', '480', '240']
                    .map(
                      (res) => PopupMenuItem(
                        value: res,
                        child: Text(
                          '${res}p${currentResolution == res ? '*' : ''}',
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
                  SizedBox(height: 20),
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
                  SizedBox(height: appH(14)),
                  BlocBuilder<CourseFilesBloc, CourseFilesState>(
                    builder: (context, state) {
                      final isLoading = state is CourseFilesLoading;
                      if (state is CourseFilesLoaded) {
                        final data = state.entity;

                        if (data.isEmpty) {
                          return _emptyFileAndTest(
                            text:
                                'Hozirda kursga tegishli hech qanday fayylar mavjud emas!',
                          );
                        }

                        return Column(
                          crossAxisAlignment: .start,
                          children: List.generate(data.length, (index) {
                            final item = data[index];
                            return DefaultCustomTileWg(
                              tileMaxLines: 1,
                              tileOverflow: .ellipsis,
                              tileLeading: SvgPicture.asset(AppVectors.pdfIcon),
                              onTap: () {
                                controller?.pause();
                                _openFile(item.file, item.fileName);
                              },
                              tileTitle: item.fileName ?? 'File ',
                              subTitle: formatFileSize(item.fileSize ?? 0),
                            );
                          }),
                        );
                      }
                      return Skeletonizer(
                        enabled: isLoading,
                        child: DefaultCustomTileWg(
                          tileMaxLines: 1,
                          tileOverflow: .ellipsis,
                          tileLeading: SvgPicture.asset(AppVectors.pdfIcon),
                          onTap: () {
                            controller?.pause();
                          },
                          tileTitle: 'Tahlil, taqqoslash va prognozlash',
                          subTitle: '3.4 MB',
                        ),
                      );
                    },
                  ),

                  /// available tests in the current course
                  SizedBox(height: appH(10)),
                  Text(
                    'Test topshiriqlar',
                    style: AppTextStyles.source.semiBold(fontSize: 17),
                  ),
                  SizedBox(height: appH(16)),
                  if (widget.testCount != 0)
                    DefaultCustomTileWg(
                      tileMaxLines: 1,
                      tileOverflow: .ellipsis,
                      tileLeading: null,
                      onTap: () async {
                        controller?.pause();
                        await openMiniAppSheetFamily(
                          context,
                          showHandler: false,
                          child: RegularTestCoursePage(),
                        );
                      },
                      tileTitle: 'Test topshirig’i',
                      subTitle: 'Mavzulashtirilgan test savollari',
                      tileAction: Icon(
                        IconlyLight.arrow_right_2,
                        color: AppColors.greyScale.grey400,
                      ),
                    )
                  else
                    _emptyFileAndTest(
                      text:
                          'Hozirda kursga tegishli hech qanday testlar mavjud emas!',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecoratedBox _emptyFileAndTest({required String text}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: .all(color: AppColors.greyScale.grey200),
        borderRadius: .circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: CustomTextStyles.h3half.copyWith(
            color: AppColors.greyScale.grey500,
            fontWeight: .w400,
          ),
        ),
      ),
    );
  }
}
