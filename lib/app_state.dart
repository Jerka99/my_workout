import 'package:my_workout/exercise.dart';
import 'package:my_workout/stopwatch_state.dart';

import 'models/exercise_session.dart';

class AppState {
  final StopwatchState stopWatchState;
  final Exercise exercise;
  final List<ExerciseSession> sessions;

  AppState({
    required this.stopWatchState,
    required this.exercise,
    required this.sessions,
  });

  static AppState initialState() => AppState(
    stopWatchState: StopwatchState.initial(),
    exercise: Exercise.initial(),
    sessions: [],
  );

  AppState copyWith({
    StopwatchState? stopWatchState,
    Exercise? exercise,
    List<ExerciseSession>? sessions,
  }) {
    return AppState(
      stopWatchState: stopWatchState ?? this.stopWatchState,
      exercise: exercise ?? this.exercise,
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  String toString() {
    return 'AppState{stopWatchState: $stopWatchState, exercise: $exercise, sessions: $sessions}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          stopWatchState == other.stopWatchState &&
          exercise == other.exercise &&
          sessions == other.sessions;

  @override
  int get hashCode => Object.hash(stopWatchState, exercise, sessions);
}
