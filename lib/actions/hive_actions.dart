import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_workout/actions/stopwatch_action.dart';
import 'package:my_workout/models/exercise.dart';
import '../app_state.dart';
import '../connectors/stopwatch_connector.dart';
import '../connectors/table_list_connector.dart';
import '../main.dart';
import '../models/exercise_session.dart';
import '../models/one_set.dart';
import '../pages/stopwatch_with_list.dart';

class AddOneSetAction extends ReduxAction<AppState> {
  final OneSet oneSet;
  final String name;

  AddOneSetAction({required this.oneSet, required this.name});

  @override
  Future<AppState?> reduce() async {
    final List<OneSet> currentList = [
      ...store.state.exercise.completedSets,
      oneSet,
    ];
    if (store.state.exercise.setsNumber != null &&
        currentList.length >= store.state.exercise.setsNumber!.toInt()) {
      await dispatch(
        SaveAndCloseAction(
          name: name,
          dateTime: DateTime.now(),
          currentList: currentList,
        ),
      );
      return null;
    }
    return state.copyWith(
      exercise: store.state.exercise.copyWith(completedSets: currentList),
    );
  }
}

class SaveAndCloseAction extends ReduxAction<AppState> {
  final String name;
  final DateTime dateTime;
  final List<OneSet> currentList;

  SaveAndCloseAction({
    required this.currentList,
    required this.name,
    required this.dateTime,
  });

  @override
  Future<AppState?> reduce() async {
    await dispatch(
      SaveToHiveAction(
        name: name,
        dateTime: dateTime,
        currentList: currentList,
      ),
    );
    await dispatch(ResetStopwatchAction());
    Navigator.pop(navKey.currentState!.context);
    return state.copyWith(exercise: Exercise.initial());
  }
}

class SaveToHiveAction extends ReduxAction<AppState> {
  final String name;
  final DateTime dateTime;
  final List<OneSet> currentList;

  SaveToHiveAction({
    required this.currentList,
    required this.name,
    required this.dateTime,
  });

  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');

    final existingList = box.get('exerciseSessions') ?? [];

    final newSession = ExerciseSession(
      exerciseName: name,
      dateTime: dateTime,
      completedSets: currentList,
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

class StartActivityAction extends ReduxAction<AppState> {
  final int? reps;
  final int? sets;
  final String exerciseName;

  StartActivityAction({
    required this.reps,
    required this.sets,
    required this.exerciseName,
  });

  @override
  Future<AppState?> reduce() async {
    Navigator.pop(navKey.currentState!.context);
    await dispatch(DisplayStopwatch(exercise: Exercise(name: exerciseName)));
    Navigator.push(
      navKey.currentState!.context,
      MaterialPageRoute(
        builder:
            (_) => StopwatchWithList(
              stopwatch: StopwatchConnector(),
              list: TableListConnector(displayEndExercise: true),
            ),
      ),
    );
    return state.copyWith(
      exercise: state.exercise.copyWith(repsNumber: reps, setsNumber: sets),
    );
  }
}

class RemoveSelectedAction extends ReduxAction<AppState> {
  final ExerciseSession selectedSession;

  RemoveSelectedAction({required this.selectedSession});

  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');
    final existingList = box.get('exerciseSessions') ?? [];

    final updatedList =
        existingList
            .map((e) => ExerciseSession.fromJson(Map<String, dynamic>.from(e)))
            .where(
              (s) =>
                  !(s.dateTime == selectedSession.dateTime &&
                      s.exerciseName == selectedSession.exerciseName),
            )
            .map((s) => s.toJson())
            .toList();

    await box.put('exerciseSessions', updatedList);

    final updatedSessions =
        state.sessions
            .where(
              (s) =>
                  !(s.dateTime == selectedSession.dateTime &&
                      s.exerciseName == selectedSession.exerciseName),
            )
            .toList();

    return state.copyWith(sessions: updatedSessions);
  }
}

class AddExerciseAction extends ReduxAction<AppState> {
  final String exerciseName;

  AddExerciseAction({required this.exerciseName});

  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');

    final List<String> existingExercises = List<String>.from(
      box.get('exerciseList') ?? [],
    );

    if (!existingExercises.contains(exerciseName)) {
      existingExercises.add(exerciseName);
      await box.put('exerciseList', existingExercises);
    }

    return state.copyWith(exerciseNames: existingExercises);
  }
}

class RemoveExerciseAction extends ReduxAction<AppState> {
  final String exerciseName;

  RemoveExerciseAction({required this.exerciseName});

  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');
    final List<String> existingExercises = List<String>.from(
      box.get('exerciseList') ?? [],
    );

    existingExercises.remove(exerciseName);
    await box.put('exerciseList', existingExercises);

    return state.copyWith(exerciseNames: existingExercises);
  }
}

class LoadExercisesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    final box = Hive.box<List>('exerciseBox');

    final List<String> exercises = List<String>.from(
      box.get('exerciseList') ?? [],
    );

    return state.copyWith(exerciseNames: exercises);
  }
}
