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
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/regular_test/regular_test_course_page.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/video_player_wg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/video_thumbnail_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_event.dart';

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
  final ValueNotifier<VideoPlayerController?> _controllerNotifier =
      ValueNotifier(null);

  final ValueNotifier<bool> _showVideoNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _hasVideoErrorNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isDownloadingNotifier = ValueNotifier(false);
  final ValueNotifier<String> _currentResolutionNotifier =
      ValueNotifier('1080');

  int _lastSentProgress = -1;
  DateTime? _lastProgressCheck;
  static const _progressCheckInterval = Duration(seconds: 2);


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
    // Video is intentionally NOT initialized here — lazy load on user tap.
  }

  @override
  void dispose() {
    // Dispose the active controller cleanly before the page is destroyed.
    _disposeController(_controllerNotifier.value);

    _controllerNotifier.dispose();
    _showVideoNotifier.dispose();
    _hasVideoErrorNotifier.dispose();
    _isDownloadingNotifier.dispose();
    _currentResolutionNotifier.dispose();
    super.dispose();
  }

  Future<void> _disposeController(VideoPlayerController? controller) async {
    if (controller == null) return;
    controller.removeListener(_videoListener);
    await controller.pause();
    await controller.dispose();
  }

  void _videoListener() {
    _onVideoProgressChanged();
  }

  void _onVideoProgressChanged() {
    final controller = _controllerNotifier.value;
    if (controller == null || !controller.value.isInitialized) return;

    // Throttle: only check every 2 seconds.
    final now = DateTime.now();
    if (_lastProgressCheck != null &&
        now.difference(_lastProgressCheck!) < _progressCheckInterval) {
      return;
    }
    _lastProgressCheck = now;

    final position = controller.value.position.inSeconds;
    final duration = controller.value.duration.inSeconds;

    if (duration <= 0) return;

    int currentProgress = ((position / duration) * 100).toInt();
    if (currentProgress > 100) currentProgress = 100;

    // First send: initialise with 0.
    if (_lastSentProgress < 0 && currentProgress >= 0) {
      _sendVideoProgress(0);
      return;
    }

    // Don't re-send after 100% has already been sent.
    if (_lastSentProgress == 100) return;

    if (currentProgress >= _lastSentProgress + 5 || currentProgress == 100) {
      _sendVideoProgress(currentProgress);
    }
  }

  void _sendVideoProgress(int progress) {
    _lastSentProgress = progress;
    context.read<LessonVideoProgressBloc>().add(
      PutLessonVideoProgressEvent(
        lessonId: widget.lessonId.toString(),
        progress: progress,
      ),
    );
  }

  Future<void> _initVideo() async {
    final token = TokenStorageServiceImpl().getAccessToken();
    if (token == null) {
      logger.e('No token found');
      return;
    }

    _hasVideoErrorNotifier.value = false;

    final resolution = _currentResolutionNotifier.value;
    final url =
        'https://test.avacoder.uz/api/stream/${widget.lessonId}/${resolution}p.m3u8';

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: {'Authorization': 'Bearer $token'},
      formatHint: VideoFormat.hls,
    )..setLooping(false);

    try {
      await newController.initialize();
    } catch (e) {
      logger.e('Video init error: $e');
      await newController.dispose();
      if (mounted) _hasVideoErrorNotifier.value = true;
      return;
    }

    newController.addListener(_videoListener);
    final oldController = _controllerNotifier.value;
    _controllerNotifier.value = newController;
    await _disposeController(oldController);

    newController.play();
  }

  Future<void> changeResolution(String newRes) async {
    final currentController = _controllerNotifier.value;
    if (newRes == _currentResolutionNotifier.value || currentController == null) {
      return;
    }

    final currentPos = currentController.value.position;
    final wasPlaying = currentController.value.isPlaying;

    await currentController.pause();

    final token = TokenStorageServiceImpl().getAccessToken();
    if (token == null) {
      logger.e('No token found');
      return;
    }

    final url =
        'https://test.avacoder.uz/api/stream/${widget.lessonId}/${newRes}p.m3u8';

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: {'Authorization': 'Bearer $token'},
      formatHint: VideoFormat.hls,
    )..setLooping(false);

    try {
      await newController.initialize();
    } catch (e) {
      logger.e('Video resolution switch error: $e');
      await newController.dispose();
      if (mounted) _hasVideoErrorNotifier.value = true;
      return;
    }

    await newController.seekTo(currentPos);
    newController.addListener(_videoListener);

    _currentResolutionNotifier.value = newRes;

    _controllerNotifier.value = newController;
    await _disposeController(currentController);

    if (wasPlaying) {
      newController.play();
    }
  }

  Future<void> _openFile(String? url, String? fileName) async {
    if (url == null || url.isEmpty || fileName == null || fileName.isEmpty) {
      errorFlushBar(context, 'Fayl manzili topilmadi');
      return;
    }

    if (_isDownloadingNotifier.value) return;
    _isDownloadingNotifier.value = true;

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
      if (mounted) _isDownloadingNotifier.value = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<LessonVideoProgressBloc, LessonVideoProgressState>(
      listener: (context, state) {
        if (state is LessonVideoProgressSuccess && state.progress == 100) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) {
              context.read<CourseLessonTopicsBloc>().add(
                CourseLessonTopicsEvent(
                  params: CourseCategoryByIdParams(id: widget.courseId),
                ),
              );
              context.read<CourseLessonItemsBloc>().add(
                CourseLessonItemsEvent(
                  params: CourseLessonItemsParams(
                    courseId: widget.courseId,
                    blockId: widget.topicId,
                  ),
                ),
              );
            }
          });
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              collapsedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _VideoAreaWidget(
                  controllerNotifier: _controllerNotifier,
                  showVideoNotifier: _showVideoNotifier,
                  hasVideoErrorNotifier: _hasVideoErrorNotifier,
                  imagePath: widget.imagePath,
                  onThumbnailTap: () {
                    _showVideoNotifier.value = true;
                    _initVideo();
                  },
                ),
              ),
              leading: Padding(
                padding: .only(left: 10, top: 10),
                child: IconButton(
                  onPressed: () {
                    _controllerNotifier.value?.pause();
                    FamilyNavigation.familyClose(context);
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(50),
                    ),
                  ),
                  icon: Icon(IconlyLight.arrow_left_2, size: 20),
                ),
              ),
              actions: [
                ValueListenableBuilder<String>(
                  valueListenable: _currentResolutionNotifier,
                  builder: (context, resolution, _) {
                    return PopupMenuButton<String>(
                      color: AppColors.white,
                      icon: Icon(
                        Icons.settings,
                        color: AppColors.greyScale.grey600,
                        size: 28,
                      ),
                      onSelected: changeResolution,
                      itemBuilder: (context) =>
                          ['1080', '720', '480', '240']
                              .map(
                                (res) => PopupMenuItem(
                                  value: res,
                                  child: Text(
                                    '${res}p${resolution == res ? '*' : ''}',
                                  ),
                                ),
                              )
                              .toList(),
                    );
                  },
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

                    /// Files section
                    SizedBox(height: appH(10)),
                    Text(
                      'Fayllar',
                      style: AppTextStyles.source.semiBold(fontSize: 17),
                    ),
                    SizedBox(height: appH(14)),
                    BlocBuilder<CourseFilesBloc, CourseFilesState>(
                      // Only rebuild when the loading/loaded/error state changes.
                      buildWhen: (prev, curr) =>
                          prev.runtimeType != curr.runtimeType,
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
                                tileLeading:
                                    SvgPicture.asset(AppVectors.pdfIcon),
                                onTap: () {
                                  _controllerNotifier.value?.pause();
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
                              _controllerNotifier.value?.pause();
                            },
                            tileTitle: 'Tahlil, taqqoslash va prognozlash',
                            subTitle: '3.4 MB',
                          ),
                        );
                      },
                    ),

                    /// Tests section
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
                          _controllerNotifier.value?.pause();
                          await openMiniAppSheetFamily(
                            context,
                            showHandler: false,
                            child: RegularTestCoursePage(
                              courseId: widget.courseId,
                              blockId: widget.topicId,
                              lessonId: widget.lessonId,
                            ),
                          );
                        },
                        tileTitle: 'Test topshirig\'i',
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  DecoratedBox _emptyFileAndTest({required String text}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          text,
          style: CustomTextStyles.h3half.copyWith(
            color: AppColors.greyScale.grey500,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

}


class _VideoAreaWidget extends StatelessWidget {
  final ValueNotifier<VideoPlayerController?> controllerNotifier;
  final ValueNotifier<bool> showVideoNotifier;
  final ValueNotifier<bool> hasVideoErrorNotifier;
  final String? imagePath;
  final VoidCallback onThumbnailTap;

  const _VideoAreaWidget({
    required this.controllerNotifier,
    required this.showVideoNotifier,
    required this.hasVideoErrorNotifier,
    required this.imagePath,
    required this.onThumbnailTap,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: hasVideoErrorNotifier,
      builder: (context, hasError, _) {
        if (hasError) return _buildNoVideoWidget(context);

        return ValueListenableBuilder<bool>(
          valueListenable: showVideoNotifier,
          builder: (context, showVideo, _) {
            if (!showVideo) {
              return VideoThumbnailWidget(
                imagePath: imagePath,
                onTap: onThumbnailTap,
              );
            }

            return ValueListenableBuilder<VideoPlayerController?>(
              valueListenable: controllerNotifier,
              builder: (context, controller, _) {
                if (controller == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                // VideoPlayerWidget is a StatefulWidget that subscribes to
                // the controller itself — no further rebuilds from here.
                return VideoPlayerWidget(controller: controller);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildNoVideoWidget(BuildContext context) {
    return Container(
      color: AppColors.greyScale.grey100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off_outlined,
            size: 52,
            color: AppColors.greyScale.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            'Video hali yuklanmagan',
            style: AppTextStyles.source.semiBold(
              fontSize: 15,
              color: AppColors.greyScale.grey600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ushbu dars uchun video mavjud emas',
            style: AppTextStyles.source.regular(
              fontSize: 13,
              color: AppColors.greyScale.grey400,
            ),
          ),
        ],
      ),
    );
  }
}
