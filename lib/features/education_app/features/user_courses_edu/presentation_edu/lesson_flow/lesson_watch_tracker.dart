import 'dart:math' as math;

class LessonWatchTracker {
  static const int bucketCount = 20;
  static const int percentStep = 5;
  static const double _requiredBucketRatio = 0.8;
  static const double _seekToleranceSeconds = 1.5;
  static const double _maxTickSeconds = 5;

  final Set<int> _watched = {};
  final Map<int, double> _playedSeconds = {};
  double? _lastPosition;
  DateTime? _lastTick;

  LessonWatchTracker({Iterable<int> watched = const []}) {
    _watched.addAll(watched);
  }

  Set<int> get watched => Set.unmodifiable(_watched);

  int get watchedPercent => _watched.length * percentStep;

  static int percentOf(int bucket) => (bucket + 1) * percentStep;

  void restore(Iterable<int> buckets) => _watched.addAll(buckets);

  void reset() {
    _watched.clear();
    _playedSeconds.clear();
    _lastPosition = null;
    _lastTick = null;
  }

  List<int> onTick({
    required double position,
    required double duration,
    required bool isPlaying,
    required double speed,
    required DateTime now,
  }) {
    final lastPosition = _lastPosition;
    final lastTick = _lastTick;
    _lastPosition = position;
    _lastTick = now;

    if (!isPlaying || duration <= 0 || lastPosition == null) return const [];
    if (lastTick == null) return const [];

    final played = position - lastPosition;
    final elapsed = math.min(
      now.difference(lastTick).inMilliseconds / 1000,
      _maxTickSeconds,
    );
    if (played <= 0 || played > elapsed * speed + _seekToleranceSeconds) {
      return const [];
    }

    final bucketLength = duration / bucketCount;
    final completed = <int>[];
    var from = lastPosition;
    while (from < position) {
      final bucket = (from / bucketLength).floor().clamp(0, bucketCount - 1);
      final bucketEnd = (bucket + 1) * bucketLength;
      final to = bucket == bucketCount - 1
          ? position
          : math.min(bucketEnd, position);
      if (to <= from) break;

      final total = (_playedSeconds[bucket] ?? 0) + (to - from);
      _playedSeconds[bucket] = total;
      if (total >= bucketLength * _requiredBucketRatio &&
          _watched.add(bucket)) {
        completed.add(bucket);
      }
      from = to;
    }
    return completed;
  }
}
