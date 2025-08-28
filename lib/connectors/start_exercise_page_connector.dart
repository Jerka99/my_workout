import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import '../actions/add_one_set_action.dart';
import '../app_state.dart';
import '../pages/start_exercise_page.dart';

class Factory
    extends VmFactory<AppState, StartExercisePageConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    onStart:
        (int? reps, int? sets, String exerciseName) async => await dispatch(
          StartActivityAction(
            reps: reps,
            sets: sets,
            exerciseName: exerciseName,
          ),
        ),
  );
}

class StartExercisePageConnector extends StatelessWidget {
  final String exerciseName;

  const StartExercisePageConnector({super.key, required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return StartExercisePage(
          exerciseName: exerciseName,
          onStart: vm.onStart,
        );
      },
    );
  }
}

class ViewModel extends Vm {
  final Function(int? reps, int? sets, String exerciseName) onStart;

  ViewModel({required this.onStart});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other && other is ViewModel && runtimeType == other.runtimeType;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() {
    return 'ViewModel{}';
  }
}
