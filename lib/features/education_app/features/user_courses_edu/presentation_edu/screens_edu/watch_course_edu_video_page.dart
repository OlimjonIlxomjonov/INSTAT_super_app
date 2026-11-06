import 'package:my_template/core/utils/general_widgets/file_download_progress/file_download_progress_wg.dart';
import 'package:dio/dio.dart' show CancelToken;
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_lesson_items/course_lesson_items_entity.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/lesson_status/lesson_status_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/test_answers/test_answers_use_cases.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_items/course_lesson_items_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_test/course_lesson_test_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/lesson_flow/lesson_nav_bar_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/lesson_flow/lesson_neighbors.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/lesson_flow/lesson_watch_status_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/lesson_flow/lesson_watch_store.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/lesson_flow/lesson_watch_tracker.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/files/remote_file_opener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/video_thumbnail_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/lesson_video_progress/lesson_video_progress_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';

class WatchCourseEduVideoPage extends StatefulWidget {
  final String title;
  final String? imagePath;
  final int courseId, topicId, lessonId;
  final int? testCount;
  final bool isFaceIdEnabled;

  const WatchCourseEduVideoPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.courseId,
    required this.topicId,
    required this.lessonId,
    required this.testCount,
    required this.isFaceIdEnabled,
  });

  @override
  State<WatchCourseEduVideoPage> createState() =>
      _WatchCourseEduVideoPageState();
}

class _WatchCourseEduVideoPageState extends State<WatchCourseEduVideoPage> {
  late String _title = widget.title;
  late String? _imagePath = widget.imagePath;
  late int _topicId = widget.topicId;
  late int _lessonId = widget.lessonId;
  late int? _testCount = widget.testCount;
  late bool _isFaceIdEnabled = widget.isFaceIdEnabled;

  void _openLesson(CourseLessonItemsEntity lesson) {
    final localeCode = Localizations.localeOf(context).languageCode;
    setState(() {
      _title = lesson.displayTitle(localeCode);
      _imagePath = lesson.thumbnail;
      _topicId = lesson.courseBlock;
      _lessonId = lesson.id;
      _testCount = lesson.testsCount;
      _isFaceIdEnabled = lesson.isFaceIdEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LessonView(
      key: ValueKey(_lessonId),
      title: _title,
      imagePath: _imagePath,
      courseId: widget.courseId,
      topicId: _topicId,
      lessonId: _lessonId,
      testCount: _testCount,
      isFaceIdEnabled: _isFaceIdEnabled,
      onOpenLesson: _openLesson,
    );
  }
}

class _LessonView extends StatefulWidget {
  final String title;
  final String? imagePath;
  final int courseId, topicId, lessonId;
  final int? testCount;
  final bool isFaceIdEnabled;
  final ValueChanged<CourseLessonItemsEntity> onOpenLesson;

  const _LessonView({
    super.key,
    required this.title,
    required this.imagePath,
    required this.courseId,
    required this.topicId,
    required this.lessonId,
    required this.testCount,
    required this.isFaceIdEnabled,
    required this.onOpenLesson,
  });

  @override
  State<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<_LessonView> {
  static const _refreshFromPercent = 50;
  static const _progressRetryDelay = Duration(seconds: 10);

  final ValueNotifier<VideoPlayerController?> _controllerNotifier =
      ValueNotifier(null);

  final ValueNotifier<bool> _showVideoNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _hasVideoErrorNotifier = ValueNotifier(false);
  final ValueNotifier<Map<String, double?>> _downloadsNotifier = ValueNotifier(
    const {},
  );
  final Map<String, CancelToken> _cancelTokens = {};
  final ValueNotifier<bool> _isCheckingTestNotifier = ValueNotifier(false);
  final ValueNotifier<String> _currentResolutionNotifier = ValueNotifier('720');

  final ValueNotifier<bool> _isSwitchingResolutionNotifier = ValueNotifier(
    false,
  );

  int _resolutionSwitchGeneration = 0;

  final LessonWatchTracker _tracker = LessonWatchTracker();
  final ValueNotifier<Set<int>> _watchedNotifier = ValueNotifier(const {});
  final List<int> _pendingPercents = [];
  final Set<int> _requestedBlocks = {};
  List<int> _blockIds = const [];
  bool _isSendingProgress = false;
  bool _hasTestAnswers = false;
  bool _didRefreshTopics = false;

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
    _loadWatchState();
  }

  CourseLessonItemsEntity? _findLesson(CourseLessonItemsState state, int? id) {
    if (id == null) return null;
    for (final block in state.loadedBlocks.values) {
      for (final lesson in block.data) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }

  bool _isWatchedIn(CourseLessonItemsState state) =>
      (_findLesson(state, widget.lessonId)?.viewedLessons ?? 0) > 0;

  bool get _isVideoWatched =>
      _isWatchedIn(context.read<CourseLessonItemsBloc>().state);

  LessonNeighbors _neighborsIn(CourseLessonItemsState state) {
    return resolveLessonNeighbors(
      blockIds: _blockIds,
      lessonsByBlock: {
        for (final entry in state.loadedBlocks.entries)
          entry.key: entry.value.data,
      },
      blockId: widget.topicId,
      lessonId: widget.lessonId,
    );
  }

  void _loadBlock(int blockId) {
    context.read<CourseLessonItemsBloc>().add(
      CourseLessonItemsEvent(
        params: CourseLessonItemsParams(
          courseId: widget.courseId,
          blockId: blockId,
        ),
      ),
    );
  }

  Future<void> _refreshBlocks(Set<int> blockIds) async {
    if (blockIds.isEmpty) return;
    final bloc = context.read<CourseLessonItemsBloc>();
    final before = bloc.state.loadedBlocks;
    final done = bloc.stream
        .firstWhere(
          (state) => blockIds.every(
            (id) =>
                !state.loadingBlocks.contains(id) &&
                (!identical(state.loadedBlocks[id], before[id]) ||
                    state.errorBlocks.containsKey(id)),
          ),
        )
        .timeout(const Duration(seconds: 20), onTimeout: () => bloc.state);
    blockIds.forEach(_loadBlock);
    await done;
  }

  void _refreshTopics() {
    context.read<CourseLessonTopicsBloc>().add(
      CourseLessonTopicsEvent(
        params: CourseCategoryByIdParams(id: widget.courseId),
      ),
    );
  }

  Future<void> _loadWatchState() async {
    final stored = await LessonWatchStore.load(widget.lessonId);
    double? userProgress;
    try {
      final status = await sl<LessonStatusUseCase>()(widget.lessonId);
      userProgress = status.userProgress;
    } catch (e) {
      logger.e(e);
    }
    await _reloadTestAnswers();
    if (!mounted) return;
    await _refreshBlocks({widget.topicId});
    if (!mounted) return;

    if (userProgress != null && userProgress <= 0) {
      if (stored.isNotEmpty) await LessonWatchStore.clear(widget.lessonId);
      return;
    }
    if (stored.isEmpty || !mounted) return;
    _tracker.restore(stored);
    _watchedNotifier.value = _tracker.watched;
    if (_isVideoWatched) return;
    _enqueueProgress(_tracker.watched);
  }

  Future<void> _reloadTestAnswers() async {
    if (widget.testCount == 0) return;
    try {
      final answers = await sl<LessonTestAnswersUseCase>()(widget.lessonId);
      if (mounted) setState(() => _hasTestAnswers = answers.isNotEmpty);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> _resetWatchProgress() async {
    await LessonWatchStore.clear(widget.lessonId);
    _tracker.reset();
    _pendingPercents.clear();
    _watchedNotifier.value = const {};
    _controllerNotifier.value?.seekTo(Duration.zero);
    if (mounted) setState(() => _hasTestAnswers = false);
  }

  Future<void> _onTestFinished(CourseLessonTestFinished result) async {
    if (!mounted) return;
    _refreshTopics();

    if (!result.isPassed) {
      await _resetWatchProgress();
      if (mounted) await _refreshBlocks({widget.topicId});
      return;
    }

    final bloc = context.read<CourseLessonItemsBloc>();
    final neighbors = _neighborsIn(bloc.state);
    await _refreshBlocks({
      widget.topicId,
      ...neighbors.blocksToLoad,
      if (neighbors.next != null) neighbors.next!.courseBlock,
    });
    if (!mounted) return;

    final next =
        _findLesson(bloc.state, result.nextLessonId) ??
        _neighborsIn(bloc.state).next;
    if (next != null) _openNeighbor(next, isNext: true);
  }

  void _openNeighbor(CourseLessonItemsEntity lesson, {required bool isNext}) {
    if (lesson.userLessons == 0) {
      final localization = AppLocalizations.of(context)!;
      errorFlushBar(
        context,
        isNext
            ? localization.lessonNextLockedHint
            : localization.noAccessToLessonYet,
      );
      return;
    }
    widget.onOpenLesson(lesson);
  }

  void _showTestLockedHint() {
    errorFlushBar(context, AppLocalizations.of(context)!.lessonTestLockedHint);
  }

  void _requestMissingBlocks(LessonNeighbors neighbors) {
    final missing = neighbors.blocksToLoad.where(_requestedBlocks.add).toList();
    if (missing.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) missing.forEach(_loadBlock);
    });
  }

  Future<void> _openLessonTest() async {
    if (_isCheckingTestNotifier.value) return;
    _isCheckingTestNotifier.value = true;

    var isFaceIdEnabled = widget.isFaceIdEnabled;
    try {
      final status = await sl<LessonStatusUseCase>()(widget.lessonId);
      isFaceIdEnabled = status.isFaceIdEnabled;
    } catch (_) {
    } finally {
      if (mounted) _isCheckingTestNotifier.value = false;
    }
    if (!mounted) return;

    final userState = context.read<UserMeBloc>().state;
    final isVerified = userState is UserMeLoaded && userState.entity.isVerified;
    if (isFaceIdEnabled && !isVerified) {
      errorFlushBar(
        context,
        AppLocalizations.of(context)!.verificationRequiredMessage,
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
        isFaceIdEnabled: isFaceIdEnabled,
        onFinished: _onTestFinished,
      ),
    );
    if (!mounted) return;
    await _reloadTestAnswers();
    if (mounted) _refreshBlocks({widget.topicId});
  }

  @override
  void dispose() {
    _disposeController(_controllerNotifier.value);

    _proxyServer?.stop();

    _controllerNotifier.dispose();
    _showVideoNotifier.dispose();
    _hasVideoErrorNotifier.dispose();
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _downloadsNotifier.dispose();
    _isCheckingTestNotifier.dispose();
    _watchedNotifier.dispose();
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

    final value = controller.value;
    final completed = _tracker.onTick(
      position: value.position.inMilliseconds / 1000,
      duration: value.duration.inMilliseconds / 1000,
      isPlaying: value.isPlaying || value.isCompleted,
      speed: value.playbackSpeed,
      now: DateTime.now(),
    );
    if (completed.isEmpty) return;

    _watchedNotifier.value = _tracker.watched;
    LessonWatchStore.save(widget.lessonId, _tracker.watched);
    if (mounted && !_isVideoWatched) _enqueueProgress(completed);
  }

  void _enqueueProgress(Iterable<int> buckets) {
    final percents = buckets.map(LessonWatchTracker.percentOf).toList()..sort();
    _pendingPercents.addAll(percents);
    _sendNextProgress();
  }

  void _sendNextProgress() {
    if (!mounted || _isSendingProgress || _pendingPercents.isEmpty) return;
    _isSendingProgress = true;
    context.read<LessonVideoProgressBloc>().add(
      PutLessonVideoProgressEvent(
        lessonId: widget.lessonId.toString(),
        progress: _pendingPercents.first,
      ),
    );
  }

  void _onProgressState(LessonVideoProgressState state) {
    if (!_isSendingProgress) return;

    if (state is LessonVideoProgressFailure) {
      _isSendingProgress = false;
      Future.delayed(_progressRetryDelay, _sendNextProgress);
      return;
    }
    if (state is! LessonVideoProgressSuccess) return;

    _isSendingProgress = false;
    if (_pendingPercents.isNotEmpty &&
        _pendingPercents.first == state.progress) {
      _pendingPercents.removeAt(0);
    }
    if (_pendingPercents.isNotEmpty) {
      _sendNextProgress();
      return;
    }

    if (_tracker.watchedPercent >= _refreshFromPercent) {
      _refreshBlocks({widget.topicId});
    }
    if (_tracker.watchedPercent == 100 && !_didRefreshTopics) {
      _didRefreshTopics = true;
      _refreshTopics();
    }
  }

  Future<void> _initVideo() async {
    final token = TokenStorageServiceImpl().getAccessToken();
    if (token == null) {
      logger.e('No token found');
      return;
    }
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

    final myGeneration = ++_resolutionSwitchGeneration;
    _isSwitchingResolutionNotifier.value = true;

    await currentController.pause();

    final token = TokenStorageServiceImpl().getAccessToken();
    if (token == null) {
      logger.e('No token found');
      if (myGeneration == _resolutionSwitchGeneration) {
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
    _currentResolutionNotifier.value = newRes;
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

    final running = _cancelTokens.remove(url);
    if (running != null) {
      running.cancel();
      _setDownload(url, null, remove: true);
      return;
    }

    final token = CancelToken();
    _cancelTokens[url] = token;
    _setDownload(url, null);
    var lastPercent = -1;
    try {
      await openRemoteFile(
        context,
        url: url,
        fileName: fileName,
        cancelToken: token,
        onProgress: (progress) {
          final percent = (progress * 100).floor();
          if (percent == lastPercent || !mounted || token.isCancelled) return;
          lastPercent = percent;
          _setDownload(url, progress);
        },
      );
    } finally {
      if (_cancelTokens[url] == token) {
        _cancelTokens.remove(url);
        if (mounted) _setDownload(url, null, remove: true);
      }
    }
  }

  void _setDownload(String url, double? progress, {bool remove = false}) {
    final next = Map<String, double?>.from(_downloadsNotifier.value);
    if (remove) {
      next.remove(url);
    } else {
      next[url] = progress;
    }
    _downloadsNotifier.value = next;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return BlocListener<LessonVideoProgressBloc, LessonVideoProgressState>(
      listener: (context, state) => _onProgressState(state),
      child: Scaffold(
        bottomNavigationBar: _buildNavBar(),
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
                        BlocBuilder<
                          CourseLessonItemsBloc,
                          CourseLessonItemsState
                        >(
                          buildWhen: (previous, current) =>
                              _isWatchedIn(previous) != _isWatchedIn(current),
                          builder: (context, state) {
                            if (_isWatchedIn(state)) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 6),
                              child: LessonWatchStatusWg(
                                watched: _watchedNotifier,
                              ),
                            );
                          },
                        ),

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
                              return ValueListenableBuilder<
                                Map<String, double?>
                              >(
                                valueListenable: _downloadsNotifier,
                                builder: (context, downloads, _) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(data.length, (index) {
                                    final item = data[index];
                                    final isDownloading =
                                        item.file != null &&
                                        downloads.containsKey(item.file);
                                    final progress = isDownloading
                                        ? downloads[item.file]
                                        : null;
                                    final size = item.fileSize ?? 0;
                                    return DefaultCustomTileWg(
                                      tileMaxLines: 1,
                                      tileOverflow: TextOverflow.ellipsis,
                                      tileLeading: isDownloading
                                          ? FileDownloadProgressWg(
                                              progress: progress,
                                            )
                                          : SvgPicture.asset(
                                              AppVectors.pdfIcon,
                                            ),
                                      onTap: () {
                                        _controllerNotifier.value?.pause();
                                        _openFile(item.file, item.fileName);
                                      },
                                      tileTitle:
                                          item.fileName ??
                                          localization.fileFallbackName,
                                      subTitle: progress != null && size > 0
                                          ? '${formatFileSize((size * progress).round())} / ${formatFileSize(size)}'
                                          : formatFileSize(size),
                                    );
                                  }),
                                ),
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

                        //! Tests section
                        const SizedBox(height: 10),
                        Text(
                          localization.testsTitle,
                          style: AppTextStyles.source.semiBold(fontSize: 17),
                        ),
                        const SizedBox(height: 16),
                        if (widget.testCount != 0)
                          BlocBuilder<
                            CourseLessonItemsBloc,
                            CourseLessonItemsState
                          >(
                            buildWhen: (previous, current) =>
                                _isWatchedIn(previous) != _isWatchedIn(current),
                            builder: (context, state) {
                              final isLocked =
                                  !_isWatchedIn(state) && !_hasTestAnswers;
                              return DefaultCustomTileWg(
                                tileMaxLines: 1,
                                tileOverflow: TextOverflow.ellipsis,
                                tileLeading: null,
                                onTap: isLocked
                                    ? _showTestLockedHint
                                    : _openLessonTest,
                                tileTitle: localization.testAssignmentTileTitle,
                                subTitle: isLocked
                                    ? localization.lessonTestLockedHint
                                    : localization.testAssignmentTileSubtitle,
                                tileAction: isLocked
                                    ? Icon(
                                        IconlyBold.lock,
                                        size: 18,
                                        color: AppColors.greyScale.grey400,
                                      )
                                    : ValueListenableBuilder<bool>(
                                        valueListenable:
                                            _isCheckingTestNotifier,
                                        builder: (_, isChecking, _) =>
                                            isChecking
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : Icon(
                                                IconlyLight.arrowRight2,
                                                color:
                                                    AppColors.greyScale.grey400,
                                              ),
                                      ),
                              );
                            },
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
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return BlocBuilder<CourseLessonTopicsBloc, CourseLessonTopicsState>(
      buildWhen: (_, current) => current is CourseLessonTopicsLoaded,
      builder: (context, topics) {
        if (topics is CourseLessonTopicsLoaded) {
          _blockIds = topics.response.data.map((topic) => topic.id).toList();
        }
        return BlocBuilder<CourseLessonItemsBloc, CourseLessonItemsState>(
          builder: (context, items) {
            final neighbors = _neighborsIn(items);
            _requestMissingBlocks(neighbors);
            final previous = neighbors.previous;
            final next = neighbors.next;
            final isNextLoading =
                next == null &&
                neighbors.isNextPending &&
                neighbors.blocksToLoad.any(items.loadingBlocks.contains);

            return LessonNavBarWg(
              showPrevious: previous != null,
              showNext: next != null || neighbors.isNextPending,
              isNextLocked: next == null || next.userLessons == 0,
              isNextLoading: isNextLoading,
              onPrevious: previous == null
                  ? null
                  : () => _openNeighbor(previous, isNext: false),
              onNext: next != null
                  ? () => _openNeighbor(next, isNext: true)
                  : isNextLoading
                  ? null
                  : () => neighbors.blocksToLoad.forEach(_loadBlock),
            );
          },
        );
      },
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
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
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
        icon: const Icon(IconlyLight.arrowLeft2, color: Colors.white, size: 20),
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
