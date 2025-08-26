import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/stopwatch_action.dart';
import 'package:my_workout/stopwatch_connector.dart';
import 'add_exercise.dart';
import 'button_with_title_below.dart';
import 'exercise.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  final List<String> exercises = ['Pull Ups', 'Push Ups', 'Squats'];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: exercises.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return ButtonWithTitleBelow(
                  icon: Icons.add,
                  text: "add",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ExerciseAddPage()),
                    );
                  },
                );
              }
              if (index == 1) {
                return ButtonWithTitleBelow(
                  icon: Icons.list,
                  text: "list",
                  onClick: () {
                    MaterialPageRoute(builder: (_) => Container());
                  },
                );
              }
              final exercise = exercises[index - 2];
              return ButtonWithTitleBelow(
                text: exercise,
                onClick: () async {
                  await store.dispatch(
                    DisplayStopwatch(
                      exercise: Exercise(name: exercise, seriesNumber: 3),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => StopwatchConnector()),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
