import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/exercise.dart';
import 'package:my_workout/preference_utils.dart';
import 'package:my_workout/stopwatch_state.dart';
import '../app_state.dart';
import 'main.dart';

class RebuildAction extends ReduxAction<AppState> {
  int time;

  RebuildAction({required this.time});

  @override
  AppState reduce() {
    return store.state.copyWith(
      stopWatchState: state.stopWatchState.copyWith(
        elapsedTime: Duration(milliseconds: time),
      ),
    );
  }
}

class SetFinishedAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    return state.copyWith(
      stopWatchState: state.stopWatchState.copyWith(
        isRunning: false,
        elapsedTime: const Duration(minutes: 30),
      ),
    );
  }
}

class DisplayStopwatch extends ReduxAction<AppState> {
  final Exercise exercise;

  DisplayStopwatch({required this.exercise});

  @override
  Future<AppState?> reduce() async {
    String? actionName = await PreferenceUtils.getString("action_name");
    if (actionName != null) return null;
    await PreferenceUtils.setInt('elapsed_time', 0);
    await PreferenceUtils.setString('action_name', exercise.name!);
    await PreferenceUtils.setInt(
      'start_time',
      DateTime.now().millisecondsSinceEpoch,
    );
    await PreferenceUtils.setBool('is_running', true);

    return state.copyWith(
      exercise: store.state.exercise.copyWith(name: exercise.name),
    );
  }

  @override
  void after() {
    // NavigationService().goBack();
    super.after();
  }
}

int sumTimeInMilliseconds(int elapsedTime) {
  return elapsedTime +
      Duration(
        milliseconds:
            DateTime.now().millisecondsSinceEpoch -
            store.state.stopWatchState.startTime,
      ).inMilliseconds;
}

class StartAfterPauseAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    bool isRunning = true;
    PreferenceUtils.setInt('start_time', startTime);
    PreferenceUtils.setBool('is_running', isRunning);

    return state.copyWith(
      stopWatchState: state.stopWatchState.copyWith(
        isRunning: isRunning,
        startTime: startTime,
      ),
    );
  }
}

class StartStopwatchAction extends ReduxAction<AppState> {
  bool startAfterPause;

  StartStopwatchAction({bool? startAfterPause})
    : startAfterPause = startAfterPause ?? false;

  @override
  Future<AppState> reduce() async {
    int elapsedTimePlusStopwatchSeconds;

    if (startAfterPause) {
      await dispatchAndWait(StartAfterPauseAction());
    }

    int elapsedTime = store.state.stopWatchState.elapsedTime.inMilliseconds;
    bool isRunning = store.state.stopWatchState.isRunning;

    if (isRunning) {
      if (prop<Timer?>("myTimer") == null) {
        setProp(
          "myTimer",
          Timer.periodic(const Duration(milliseconds: 250), (timer) async {
            elapsedTimePlusStopwatchSeconds = sumTimeInMilliseconds(
              elapsedTime,
            );
            setProp("currentTick", elapsedTimePlusStopwatchSeconds);
            dispatch(RebuildAction(time: elapsedTimePlusStopwatchSeconds));
          }),
        );
      }
    }

    return state.copyWith(
      stopWatchState: state.stopWatchState.copyWith(isRunning: isRunning),
    );
  }
}

class StopTimerAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    Timer? timer = prop<Timer?>("myTimer");
    int? currentTick = prop<int?>("currentTick");

    if (timer != null) {
      timer.cancel();
      setProp("myTimer", null);
    }
    if (currentTick != null) {
      setProp("currentTick", null);
    }

    return null;
  }
}

class PauseStopwatchAction extends ReduxAction<AppState> {
  PauseStopwatchAction();

  @override
  Future<AppState?> reduce() async {
    if (prop<int?>("currentTick") != null) {
      int currentTick = prop<int?>("currentTick") ?? 0;
      PreferenceUtils.setInt('elapsed_time', currentTick);
      PreferenceUtils.setBool('is_running', false);
      await dispatch(StopTimerAction());
      return state.copyWith(
        stopWatchState: state.stopWatchState.copyWith(
          isRunning: false,
          elapsedTime: Duration(milliseconds: currentTick),
        ),
      );
    }
    return null;
  }
}

class AskForResetStopwatchAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    showDialog(
      context: navKey.currentState!.overlay!.context,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              height: 144,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ARE YOU SURE TOU WANT TO END ACTIVITY?",
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: Text(
                            "CONTINUE ACTIVITY",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          child: Text(
                            "END ACTIVITY",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            dispatch(ResetStopwatchAction());
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return null;
  }
}

class ResetStopwatchAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    PreferenceUtils.remove('elapsed_time');
    PreferenceUtils.remove('start_time');
    PreferenceUtils.remove('is_running');
    PreferenceUtils.remove('action_id');
    PreferenceUtils.remove('action_name');

    dispatch(StopTimerAction());

    return state.copyWith(
      stopWatchState: StopwatchState.initial(),
      exercise: Exercise.initial(),
    );
  }
}

class LoadStartTimeAction extends ReduxAction<AppState> {
  @override
  void after() {
    if (store.state.stopWatchState.isRunning) dispatch(StartStopwatchAction());
    super.after();
  }

  @override
  Future<AppState?> reduce() async {
    bool? isRunning = PreferenceUtils.getBool('is_running') ?? false;
    int? savedElapsed = PreferenceUtils.getInt('elapsed_time');
    int? startTime = PreferenceUtils.getInt('start_time');
    String? actionName = PreferenceUtils.getString("action_name");

    Duration elapsedTime = Duration(milliseconds: savedElapsed ?? 0);

    return state.copyWith(
      exercise: state.exercise.copyWith(name: actionName),
      stopWatchState: state.stopWatchState.copyWith(
        isRunning: isRunning,
        elapsedTime: elapsedTime,
        startTime: startTime,
      ),
    );
  }
}
