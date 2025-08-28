import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/connectors/stopwatch_connector.dart';
import 'package:my_workout/main.dart';
import 'package:rotary_scrollbar/widgets/rotary_scrollbar.dart';
import '../connectors/start_exercise_page_connector.dart';
import 'add_exercise_page.dart';
import '../widget_helper/button_with_title_below.dart';
import '../connectors/list_connector.dart';
import '../connectors/table_list_connector.dart';
import '../models/exercise.dart';

class HomePage extends StatefulWidget {
  final Exercise? activeExercise;

  HomePage({super.key, this.activeExercise});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> exercises = ['Pull Ups', 'Push Ups', 'Squats'];
  final _scrollController = PageController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Container(
          color: Colors.grey[900],
          child: RotaryScrollbar(
            controller: _scrollController,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemCount: exercises.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ButtonWithTitleBelow(
                    icon: Icons.add,
                    text: "Add",
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
                    text: "List",
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
                    if (store.state.exercise.name != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => StopwatchWithList(
                                stopwatch: StopwatchConnector(),
                                list: TableListConnector(),
                              ),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => StartExercisePageConnector(
                              exerciseName: exercise,
                            ),
                      ),
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
  final _scrollController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: RotaryScrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            widget.stopwatch,
            Container(height: 22),
            Padding(padding: const EdgeInsets.all(12.0), child: widget.list,),
            Container(height: 30),
          ],
        ),
      ),
    );
  }
}
