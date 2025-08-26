class StopwatchState {
  final Duration elapsedTime;
  final bool isRunning;
  final int startTime;
  final int? currentTime;

  StopwatchState({
    required this.elapsedTime,
    required this.isRunning,
    required this.startTime,
    required this.currentTime,
  });

  factory StopwatchState.initial() {
    return StopwatchState(
      elapsedTime: Duration.zero,
      isRunning: false,
      startTime: 0,
      currentTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  StopwatchState copyWith({
    Duration? elapsedTime,
    bool? isRunning,
    int? startTime,
    int? currentTime,
  }) {
    return StopwatchState(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isRunning: isRunning ?? this.isRunning,
      startTime: startTime ?? this.startTime,
      currentTime: currentTime ?? this.currentTime,
    );
  }


  @override
  String toString() {
    return 'StopwatchState{elapsedTime: $elapsedTime, isRunning: $isRunning, startTime: $startTime, currentTime: $currentTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is StopwatchState &&
              runtimeType == other.runtimeType &&
              elapsedTime == other.elapsedTime &&
              isRunning == other.isRunning &&
              startTime == other.startTime &&
              currentTime == other.currentTime;

  @override
  int get hashCode =>
      elapsedTime.hashCode ^
      isRunning.hashCode ^
      startTime.hashCode ^
      currentTime.hashCode;
}

