import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/exercise.dart';
import '../../../main.dart';
import '../app_state.dart';
import '../pages/table_list.dart';

class Factory extends VmFactory<AppState, TableListConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(exercise: store.state.exercise);
}

class TableListConnector extends StatelessWidget {
  const TableListConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      builder: (BuildContext context, ViewModel vm) {
        return TableList(exercise: vm.exercise);
      },
    );
  }
}

class ViewModel extends Vm {
  final Exercise? exercise;

  ViewModel({required this.exercise});

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
