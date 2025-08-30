import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/pages/add_exercise_page.dart';
import '../actions/hive_actions.dart';
import '../app_state.dart';

class Factory extends VmFactory<AppState, AddExerciseConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    addExercise:
        (String exerciseName) =>
            dispatch(AddExerciseAction(exerciseName: exerciseName)),
  );
}

class AddExerciseConnector extends StatelessWidget {
  const AddExerciseConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return AddExercisePage(addExercise: vm.addExercise);
      },
    );
  }
}

class ViewModel extends Vm {
  final Function(String exerciseName) addExercise;

  ViewModel({required this.addExercise});
}
