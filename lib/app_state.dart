import 'package:my_workout/models/exercise.dart';
import 'package:my_workout/stopwatch_state.dart';

import 'models/exercise_session.dart';

class AppState {
  final StopwatchState stopWatchState;
  final Exercise exercise;
  final List<ExerciseSession> sessions;
  final List<String> exerciseNames;

  AppState({
    required this.stopWatchState,
    required this.exercise,
    required this.sessions,
    required this.exerciseNames,
  });

  static AppState initialState() => AppState(
    stopWatchState: StopwatchState.initial(),
    exercise: Exercise.initial(),
    sessions: [],
    exerciseNames: [],
  );

  AppState copyWith({
    StopwatchState? stopWatchState,
    Exercise? exercise,
    List<ExerciseSession>? sessions,
    List<String>? exerciseNames,
  }) {
    return AppState(
      stopWatchState: stopWatchState ?? this.stopWatchState,
      exercise: exercise ?? this.exercise,
      sessions: sessions ?? this.sessions,
      exerciseNames: exerciseNames ?? this.exerciseNames,
    );
  }

  @override
  String toString() {
    return 'AppState{stopWatchState: $stopWatchState, exercise: $exercise, sessions: $sessions, exerciseNames: $exerciseNames}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          stopWatchState == other.stopWatchState &&
          exercise == other.exercise &&
          sessions == other.sessions &&
          exerciseNames == other.exerciseNames;

  @override
  int get hashCode =>
      Object.hash(stopWatchState, exercise, sessions, exerciseNames);
}
