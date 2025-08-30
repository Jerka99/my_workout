import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/actions/hive_actions.dart';
import '../../../main.dart';
import '../app_state.dart';
import '../models/exercise_session.dart';
import '../pages/list_page.dart';
import '../widget_helper/my_dialog.dart';

class Factory extends VmFactory<AppState, ListConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(
    sessionList: store.state.sessions,
    onLongPressEnd: (ExerciseSession selectedSession) {
      showDialog(
        context: navKey.currentState!.overlay!.context,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: MyDialog(
              onLeftButton: () {
                Navigator.of(context).pop();
              },
              onRightButton: () {
                dispatch(
                  RemoveSelectedAction(selectedSession: selectedSession),
                );
                Navigator.of(context).pop();
              },
              leftText: "Cancel",
              rightText: "Delete",
              title: "Are you sure you want to delete this session?",
            ),
          );
        },
      );
    },
  );
}

class ListConnector extends StatelessWidget {
  const ListConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ViewModel>(
      vm: () => Factory(),
      onInit: (store) async {
        await store.dispatch(LoadHiveListAction());
      },
      builder: (BuildContext context, ViewModel vm) {
        return ListPage(
          sessionList: vm.sessionList,
          onLongPressEnd: vm.onLongPressEnd,
        );
      },
    );
  }
}

class ViewModel extends Vm {
  final List<ExerciseSession> sessionList;
  final Function(ExerciseSession selectedSession) onLongPressEnd;

  ViewModel({required this.onLongPressEnd, required this.sessionList})
    : super(equals: [sessionList]);
}
