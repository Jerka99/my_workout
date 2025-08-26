import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/exercise.dart';
import 'package:my_workout/stopwatch_action.dart';
import 'package:my_workout/stopwatch_widget.dart';
import '../../../main.dart';
import '../app_state.dart';

class Factory extends VmFactory<AppState, StopwatchConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    elapsedTime: store.state.stopWatchState.elapsedTime,
    isRunning: store.state.stopWatchState.isRunning,
    startStopwatch:
        () => store.dispatch(StartStopwatchAction(startAfterPause: true)),
    pauseStopwatch: () => store.dispatch(PauseStopwatchAction()),
    resetStopwatch: () => store.dispatch(AskForResetStopwatchAction()),
    exercise: store.state.exercise,
    time: store.state.stopWatchState.elapsedTime.inSeconds,
  );
}

class StopwatchConnector extends StatelessWidget {
  const StopwatchConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      onInit: (store) {
        if (store.prop<Timer?>("myTimer") == null) {
          store.dispatchAndWait(LoadStartTimeAction());
        }
      },
      // onDispose: (store) => store.dispatch(OnDisposeAction()),
      builder: (BuildContext context, ViewModel vm) {
        return StopwatchWidget(
          time: vm.time!,
          elapsedTime: vm.elapsedTime,
          isRunning: vm.isRunning,
          startStopwatch: vm.startStopwatch,
          pauseStopwatch: vm.pauseStopwatch,
          resetStopwatch: vm.resetStopwatch,
          exercise: vm.exercise,
        );
      },
    );
  }
}

class ViewModel extends Vm {
  final Duration elapsedTime;
  final bool isRunning;
  final Function startStopwatch;
  final Function pauseStopwatch;
  final Function resetStopwatch;
  final Exercise? exercise;
  final int? time;

  ViewModel({
    this.time,
    required this.elapsedTime,
    required this.isRunning,
    required this.startStopwatch,
    required this.pauseStopwatch,
    required this.resetStopwatch,
    required this.exercise,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          elapsedTime == other.elapsedTime &&
          isRunning == other.isRunning &&
          time == other.time &&
          exercise == other.exercise;

  @override
  int get hashCode =>
      super.hashCode ^
      elapsedTime.hashCode ^
      isRunning.hashCode ^
      exercise.hashCode ^
      time.hashCode;

  @override
  String toString() {
    return 'ViewModel{elapsedTime: $elapsedTime, isRunning: $isRunning, exercise: $exercise, time: $time}';
  }
}
