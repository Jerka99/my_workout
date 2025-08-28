import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/exercise.dart';
import 'package:my_workout/pages/home_page.dart';
import 'package:my_workout/actions/stopwatch_action.dart';
import 'package:my_workout/stopwatch_widget.dart';
import '../../../main.dart';
import '../app_state.dart';

class Factory extends VmFactory<AppState, HomePageConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    exercise: store.state.exercise,
    onActivitySelect:
        (Exercise exercise) async => await dispatch(DisplayStopwatch(exercise: exercise)),
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
      },
      builder: (BuildContext context, ViewModel vm) {
        return HomePage(
          activeExercise: vm.exercise,
          onActivitySelect: vm.onActivitySelect,
        );
      },
    );
  }
}

class ViewModel extends Vm {
  final Exercise? exercise;
  final Function(Exercise exercise) onActivitySelect;

  ViewModel({required this.exercise, required this.onActivitySelect});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          exercise == other.exercise;

  @override
  int get hashCode => super.hashCode ^ exercise.hashCode;

  @override
  String toString() {
    return 'ViewModel{exercise: $exercise}';
  }
}
