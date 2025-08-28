import 'package:async_redux/async_redux.dart';
import 'package:hive_flutter/adapters.dart';
import '../app_state.dart';
import '../models/exercise_session.dart';
import '../models/one_set.dart';

class AddOneSetAction extends ReduxAction<AppState> {
  final OneSet oneSet;
  final String name;

  AddOneSetAction({required this.oneSet, required this.name});

  @override
  AppState reduce() {
    final List<OneSet> currentList = [
      ...store.state.exercise.completedSets,
      oneSet,
    ];
    if (currentList.length >= 2) {
      dispatch(SaveToHiveAction(name: name, dateTime: DateTime.now()));
    }
    return state.copyWith(
      exercise: store.state.exercise.copyWith(completedSets: currentList),
    );
  }
}

class SaveToHiveAction extends ReduxAction<AppState> {
  final String name;
  final DateTime dateTime;

  SaveToHiveAction({required this.name, required this.dateTime});

  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');

    final existingList = box.get('exerciseSessions') ?? [];

    final newSession = ExerciseSession(
      exerciseName: name,
      dateTime: dateTime,
      completedSets: store.state.exercise.completedSets,
    );
    final mergedList = [...existingList, newSession.toJson()];
    await box.put('exerciseSessions', mergedList);

    return null;
  }
}

class LoadHiveListAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');
    final list = box.get('exerciseSessions') ?? [];

    final sessions =
        list
            .map((e) => ExerciseSession.fromJson(Map<String, dynamic>.from(e)))
            .toList();

    return state.copyWith(sessions: sessions);
  }
}
