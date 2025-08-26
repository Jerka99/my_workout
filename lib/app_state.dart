import 'package:my_workout/exercise.dart';
import 'package:my_workout/stopwatch_state.dart';

class AppState {
  final StopwatchState stopWatchState;
  final Exercise exercise;

  AppState({required this.stopWatchState, required this.exercise});

  static AppState initialState() => AppState(
    stopWatchState: StopwatchState.initial(),
    exercise: Exercise.initial(),
  );

  AppState copyWith({StopwatchState? stopWatchState, Exercise? exercise}) {
    return AppState(
      stopWatchState: stopWatchState ?? this.stopWatchState,
      exercise: exercise ?? this.exercise,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          stopWatchState == other.stopWatchState &&
          exercise == other.exercise;

  @override
  int get hashCode => stopWatchState.hashCode ^ exercise.hashCode;

  @override
  String toString() {
    return 'AppState{stopWatchState: $stopWatchState, exercise: $exercise}';
  }
}
