import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/models/exercise.dart';
import '../../../main.dart';
import '../actions/hive_actions.dart';
import '../app_state.dart';
import '../pages/table_list_page.dart';

class Factory extends VmFactory<AppState, TableListConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    exercise: store.state.exercise,
    endActivity:
        (String name) => dispatch(
          SaveAndCloseAction(
            name: name,
            dateTime: DateTime.now(),
            currentList: store.state.exercise.completedSets,
          ),
        ),
  );
}

class TableListConnector extends StatelessWidget {
  final bool displayEndExercise;

  const TableListConnector({super.key, bool? displayEndExercise})
    : displayEndExercise = displayEndExercise ?? false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return TableListPage(
          exercise: vm.exercise,
          displayEndExercise: displayEndExercise,
          endActivity: vm.endActivity,
        );
      },
    );
  }
}

class ViewModel extends Vm {
  final Exercise? exercise;
  final Function(String name)? endActivity;

  ViewModel({required this.exercise, this.endActivity});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ViewModel &&
          runtimeType == other.runtimeType &&
          exercise == other.exercise;

  @override
  int get hashCode => Object.hash(super.hashCode, exercise.hashCode);

  @override
  String toString() {
    return 'ViewModel{exercise: $exercise}';
  }
}
