import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/connectors/stopwatch_connector.dart';
import 'package:rotary_scrollbar/widgets/rotary_scrollbar.dart';
import '../add_exercise.dart';
import '../button_with_title_below.dart';
import '../connectors/list_connector.dart';
import '../connectors/table_list_connector.dart';
import '../exercise.dart';

class HomePage extends StatefulWidget {
  final Exercise? activeExercise;
  final Function(Exercise exercise) onActivitySelect;

  HomePage({super.key, this.activeExercise, required this.onActivitySelect});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> exercises = ['Pull Ups', 'Push Ups', 'Squats'];
  final scrollController = PageController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        body: Container(
          color: Colors.grey[900],
          child: RotaryScrollbar(
            controller: scrollController,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: scrollController,
              // scrollDirection: Axis.horizontal,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ListConnector()),
                      );
                    },
                  );
                }
                final exercise = exercises[index - 2];
                return ButtonWithTitleBelow(
                  enabledColor: const Color.fromARGB(255, 255, 166, 0),
                  enabled:
                      widget.activeExercise?.name == exercise ||
                      widget.activeExercise?.name == null,
                  text: exercise,
                  onClick: () async {
                    await widget.onActivitySelect(Exercise(name: exercise));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => Scaffold(
                              // backgroundColor: Colors.black,
                              body: StopwatchWithList(
                                stopwatch: StopwatchConnector(),
                                list: TableListConnector(),
                              ),
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class StopwatchWithList extends StatefulWidget {
  final Widget stopwatch;
  final Widget list;

  const StopwatchWithList({
    super.key,
    required this.stopwatch,
    required this.list,
  });

  @override
  State<StopwatchWithList> createState() => _StopwatchWithListState();
}

class _StopwatchWithListState extends State<StopwatchWithList> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 200,
        color: Colors.grey[900],
        child: ListView(
          children: [widget.stopwatch, Container(height: 22), widget.list],
        ),
      ),
    );
  }
}
