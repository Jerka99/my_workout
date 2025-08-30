import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/models/exercise.dart';
import 'package:my_workout/pages/home_page.dart';
import 'package:my_workout/actions/stopwatch_action.dart';
import '../../../main.dart';
import '../actions/hive_actions.dart';
import '../app_state.dart';

class Factory extends VmFactory<AppState, HomePageConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    exercise: store.state.exercise,
    exerciseNames: store.state.exerciseNames,
    removeExerciseName:
        (String exerciseName) =>
            dispatch(RemoveExerciseAction(exerciseName: exerciseName)),
  );
}

class HomePageConnector extends StatelessWidget {
  const HomePageConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      onInit: (store) async {
        if (store.prop<Timer?>("myTimer") == null) {
          await store.dispatchAndWait(LoadStartTimeAction());
        }
        store.dispatch(LoadExercisesAction());
      },
      builder: (BuildContext context, ViewModel vm) {
        return HomePage(
          activeExercise: vm.exercise,
          exerciseNames: vm.exerciseNames,
          removeExerciseName: vm.removeExerciseName,
        );
      },
    );
  }
}

class ViewModel extends Vm {
  final Exercise? exercise;
  final List<String> exerciseNames;
  final Function(String exerciseName) removeExerciseName;

  ViewModel({
    required this.removeExerciseName,
    required this.exerciseNames,
    required this.exercise,
  });

  @override
  String toString() {
    return 'ViewModel{exercise: $exercise, exerciseNames: $exerciseNames}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          exercise == other.exercise &&
          exerciseNames == other.exerciseNames;

  @override
  int get hashCode => Object.hash(super.hashCode, exercise, exerciseNames);
}
