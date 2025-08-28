import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/actions/add_one_set_action.dart';
import '../../../main.dart';
import '../app_state.dart';
import '../models/exercise_session.dart';
import '../pages/list_page.dart';

class Factory extends VmFactory<AppState, ListConnector, ViewModel> {
  @override
  ViewModel fromStore() => ViewModel(sessionList: store.state.sessions);
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
        return ListPage(sessionList: vm.sessionList);
      },
    );
  }
}

class ViewModel extends Vm {
  final List<ExerciseSession> sessionList;

  ViewModel({required this.sessionList}) : super(equals: [sessionList]);
}
