import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/services/token_storage/token_storage_service_impl.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
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
import 'package:my_template/core/utils/general_widgets/file_opening_overlay/file_opening_overlay_wg.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';

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
  final ValueNotifier<String> _currentResolutionNotifier = ValueNotifier(
    '1080',
  );
  final ValueNotifier<bool> _isSwitchingResolutionNotifier = ValueNotifier(
    false,
  );
  // Bumped on every changeResolution() call so a slow, now-stale switch
  // can't clobber a newer one that finished first (or reset the spinner
  // it's still showing).
  int _resolutionSwitchGeneration = 0;

  int _lastSentProgress = -1;
  DateTime? _lastProgressCheck;
  static const _progressCheckInterval = Duration(seconds: 2);

  HlsProxyServer? _proxyServer;

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

    _proxyServer?.stop();

    _controllerNotifier.dispose();
    _showVideoNotifier.dispose();
    _hasVideoErrorNotifier.dispose();
    _isDownloadingNotifier.dispose();
    _currentResolutionNotifier.dispose();
    _isSwitchingResolutionNotifier.dispose();
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
    logger.f(token);
    _hasVideoErrorNotifier.value = false;

    // Start HLS Local Proxy Server
    if (_proxyServer != null) {
      await _proxyServer!.stop();
    }
    _proxyServer = HlsProxyServer(token: token);
    final port = await _proxyServer!.start();

    final resolution = _currentResolutionNotifier.value;
    final localUrl =
        'http://127.0.0.1:$port/api/stream/${widget.lessonId}/${resolution}p.m3u8';

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(localUrl),
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
    final previousRes = _currentResolutionNotifier.value;
    if (newRes == previousRes || currentController == null) {
      return;
    }

    final currentPos = currentController.value.position;
    final wasPlaying = currentController.value.isPlaying;

    // Optimistic UI: reflect the pick and show a spinner immediately,
    // instead of leaving the paused old frame with no feedback while the
    // new stream loads in the background. A generation token means that if
    // the user taps another quality before this one finishes, this call's
    // result gets silently discarded instead of clobbering the newer pick.
    final myGeneration = ++_resolutionSwitchGeneration;
    _currentResolutionNotifier.value = newRes;
    _isSwitchingResolutionNotifier.value = true;

    await currentController.pause();

    final token = TokenStorageServiceImpl().getAccessToken();
    if (token == null) {
      logger.e('No token found');
      if (mounted && myGeneration == _resolutionSwitchGeneration) {
        _currentResolutionNotifier.value = previousRes;
        _isSwitchingResolutionNotifier.value = false;
      }
      return;
    }

    // Reuse HLS Local Proxy Server
    int port;
    if (_proxyServer == null) {
      _proxyServer = HlsProxyServer(token: token);
      port = await _proxyServer!.start();
    } else {
      port = _proxyServer!.port;
    }

    final localUrl =
        'http://127.0.0.1:$port/api/stream/${widget.lessonId}/${newRes}p.m3u8';

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(localUrl),
      formatHint: VideoFormat.hls,
    )..setLooping(false);

    try {
      await newController.initialize();
    } catch (e) {
      logger.e('Video resolution switch error: $e');
      await newController.dispose();
      // A newer switch has since started — let it own the UI state.
      if (myGeneration != _resolutionSwitchGeneration) return;
      if (mounted) {
        _hasVideoErrorNotifier.value = true;
        _currentResolutionNotifier.value = previousRes;
        _isSwitchingResolutionNotifier.value = false;
      }
      return;
    }

    await newController.seekTo(currentPos);

    if (myGeneration != _resolutionSwitchGeneration) {
      // Superseded by a later pick while this one was loading — drop it.
      await newController.dispose();
      return;
    }

    newController.addListener(_videoListener);
    _controllerNotifier.value = newController;
    await _disposeController(currentController);

    _isSwitchingResolutionNotifier.value = false;

    if (wasPlaying) {
      newController.play();
    }
  }

  Future<void> _openFile(String? url, String? fileName) async {
    final localization = AppLocalizations.of(context)!;
    if (url == null || url.isEmpty || fileName == null || fileName.isEmpty) {
      errorFlushBar(context, localization.fileUrlNotFound);
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
        errorFlushBar(context, localization.fileOpenError(result.message));
      }
    } catch (e) {
      if (mounted) {
        errorFlushBar(context, localization.fileDownloadError);
      }
      logger.e(e.toString());
    } finally {
      if (mounted) _isDownloadingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
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
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  collapsedHeight: 250,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _VideoAreaWidget(
                      controllerNotifier: _controllerNotifier,
                      showVideoNotifier: _showVideoNotifier,
                      hasVideoErrorNotifier: _hasVideoErrorNotifier,
                      imagePath: widget.imagePath,
                      currentResolutionNotifier: _currentResolutionNotifier,
                      isSwitchingResolutionNotifier:
                          _isSwitchingResolutionNotifier,
                      onResolutionSelected: changeResolution,
                      onThumbnailTap: () {
                        _showVideoNotifier.value = true;
                        _initVideo();
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: AppPadding.horizontal20x(),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          widget.title,
                          style: AppTextStyles.source.medium(fontSize: 20),
                        ),
                        Divider(color: AppColors.greyScale.grey200),

                        /// Files section
                        const SizedBox(height: 10),
                        Text(
                          localization.filesTitle,
                          style: AppTextStyles.source.semiBold(fontSize: 17),
                        ),
                        const SizedBox(height: 14),
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
                                  text: localization.noFilesAvailable,
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(data.length, (index) {
                                  final item = data[index];
                                  return DefaultCustomTileWg(
                                    tileMaxLines: 1,
                                    tileOverflow: TextOverflow.ellipsis,
                                    tileLeading: SvgPicture.asset(
                                      AppVectors.pdfIcon,
                                    ),
                                    onTap: () {
                                      _controllerNotifier.value?.pause();
                                      _openFile(item.file, item.fileName);
                                    },
                                    tileTitle:
                                        item.fileName ??
                                        localization.fileFallbackName,
                                    subTitle: formatFileSize(
                                      item.fileSize ?? 0,
                                    ),
                                  );
                                }),
                              );
                            }
                            return Skeletonizer(
                              enabled: isLoading,
                              child: DefaultCustomTileWg(
                                tileMaxLines: 1,
                                tileOverflow: TextOverflow.ellipsis,
                                tileLeading: SvgPicture.asset(
                                  AppVectors.pdfIcon,
                                ),
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
                        const SizedBox(height: 10),
                        Text(
                          localization.testsTitle,
                          style: AppTextStyles.source.semiBold(fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                        if (widget.testCount != 0)
                          DefaultCustomTileWg(
                            tileMaxLines: 1,
                            tileOverflow: TextOverflow.ellipsis,
                            tileLeading: null,
                            onTap: () async {
                              final userState = context
                                  .read<UserMeBloc>()
                                  .state;
                              final isVerified =
                                  userState is UserMeLoaded &&
                                  userState.entity.isVerified;

                              if (!isVerified) {
                                errorFlushBar(
                                  context,
                                  localization.verificationRequiredMessage,
                                );
                                return;
                              }

                              _controllerNotifier.value?.pause();
                              await openMiniAppSheetFamily(
                                context,
                                showHandler: false,
                                enableDrag: false,
                                child: RegularTestCoursePage(
                                  courseId: widget.courseId,
                                  blockId: widget.topicId,
                                  lessonId: widget.lessonId,
                                ),
                              );
                            },
                            tileTitle: localization.testAssignmentTileTitle,
                            subTitle: localization.testAssignmentTileSubtitle,
                            tileAction: Icon(
                              IconlyLight.arrow_right_2,
                              color: AppColors.greyScale.grey400,
                            ),
                          )
                        else
                          _emptyFileAndTest(
                            text: localization.noTestsAvailable,
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _isDownloadingNotifier,
              builder: (context, isDownloading, _) {
                if (!isDownloading) return const SizedBox.shrink();
                return const FileOpeningOverlayWg();
              },
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
  final ValueNotifier<String> currentResolutionNotifier;
  final ValueNotifier<bool> isSwitchingResolutionNotifier;
  final ValueChanged<String> onResolutionSelected;
  final VoidCallback onThumbnailTap;

  const _VideoAreaWidget({
    required this.controllerNotifier,
    required this.showVideoNotifier,
    required this.hasVideoErrorNotifier,
    required this.imagePath,
    required this.currentResolutionNotifier,
    required this.isSwitchingResolutionNotifier,
    required this.onResolutionSelected,
    required this.onThumbnailTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<bool>(
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
                    return VideoPlayerWidget(
                      controller: controller,
                      currentResolutionNotifier: currentResolutionNotifier,
                      isSwitchingResolutionNotifier:
                          isSwitchingResolutionNotifier,
                      onResolutionSelected: onResolutionSelected,
                      onBack: () {
                        controller.pause();
                        FamilyNavigation.familyClose(context);
                      },
                    );
                  },
                );
              },
            );
          },
        ),

        // Display static back button when video has NOT loaded (thumbnail, loading, error state)
        ValueListenableBuilder<bool>(
          valueListenable: hasVideoErrorNotifier,
          builder: (context, hasError, _) {
            if (hasError) {
              return _buildStaticBackButton(context);
            }
            return ValueListenableBuilder<bool>(
              valueListenable: showVideoNotifier,
              builder: (context, showVideo, _) {
                if (!showVideo) {
                  return _buildStaticBackButton(context);
                }
                return ValueListenableBuilder<VideoPlayerController?>(
                  valueListenable: controllerNotifier,
                  builder: (context, controller, _) {
                    final isInitialized =
                        controller?.value.isInitialized ?? false;
                    if (!isInitialized) {
                      return _buildStaticBackButton(context);
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildStaticBackButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 12,
      child: IconButton(
        onPressed: () {
          controllerNotifier.value?.pause();
          FamilyNavigation.familyClose(context);
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.black38,
          shape: const CircleBorder(),
        ),
        icon: const Icon(
          IconlyLight.arrow_left_2,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildNoVideoWidget(BuildContext context) {
    return Container(
      width: double.infinity,
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
            AppLocalizations.of(context)!.videoNotUploadedYet,
            style: AppTextStyles.source.semiBold(
              fontSize: 15,
              color: AppColors.greyScale.grey600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.noVideoForLesson,
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

// HLS Proxy Server to inject Authorization header and rewrite URLs
class HlsProxyServer {
  HttpServer? _server;
  final String remoteBaseUrl =
      ApiUrls.videoBase; // Updated to actual backend URL
  final String token;

  HlsProxyServer({required this.token});

  int get port => _server?.port ?? 0;

  Future<int> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen(
      _handleRequest,
      onError: (error) {
        // Handle server error if needed
      },
    );
    return _server!.port;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
  }

  void _handleRequest(HttpRequest request) async {
    final client = HttpClient();
    try {
      final remoteUri = Uri.parse(remoteBaseUrl).replace(
        path: request.uri.path,
        queryParameters: request.uri.queryParameters.isNotEmpty
            ? request.uri.queryParameters
            : null,
      );

      final remoteRequest = await client.openUrl(request.method, remoteUri);

      // Copy incoming request headers to remote request
      request.headers.forEach((name, values) {
        if (name != 'host' &&
            name != 'connection' &&
            name != 'accept-encoding') {
          for (var value in values) {
            remoteRequest.headers.add(name, value);
          }
        }
      });

      // Inject the Authorization token
      remoteRequest.headers.set('Authorization', 'Bearer $token');

      // Forward request body if any
      if (request.contentLength > 0) {
        await remoteRequest.addStream(request);
      }

      final remoteResponse = await remoteRequest.close();

      // Set status code
      request.response.statusCode = remoteResponse.statusCode;

      // Copy repository headers
      remoteResponse.headers.forEach((name, values) {
        if (name != 'content-length') {
          for (var value in values) {
            request.response.headers.add(name, value);
          }
        }
      });

      bool isM3u8 =
          request.uri.path.endsWith('.m3u8') ||
          remoteResponse.headers.value('content-type')?.contains('mpegurl') ==
              true;

      if (isM3u8) {
        final bodyBytes = await remoteResponse
            .expand((chunk) => chunk)
            .toList();
        final bodyString = utf8.decode(bodyBytes);

        // Rewrite remote URL to local proxy address
        final localAddress = 'http://127.0.0.1:$port';
        final rewrittenBody = bodyString.replaceAll(
          remoteBaseUrl,
          localAddress,
        );

        final responseBytes = utf8.encode(rewrittenBody);
        request.response.headers.set(
          'content-length',
          responseBytes.length.toString(),
        );
        request.response.add(responseBytes);
      } else {
        // Stream segments/content directly
        await request.response.addStream(remoteResponse);
      }
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
    } finally {
      await request.response.close();
      client.close();
    }
  }
}
