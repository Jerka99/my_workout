import 'package:flutter/material.dart';
import 'package:my_workout/connectors/add_exercise_connector.dart';
import 'package:my_workout/connectors/stopwatch_connector.dart';
import 'package:my_workout/main.dart';
import 'package:rotary_scrollbar/widgets/rotary_scrollbar.dart';
import '../connectors/start_exercise_page_connector.dart';
import '../widget_helper/my_dialog.dart';
import '../widget_helper/button_with_title_below.dart';
import '../connectors/list_connector.dart';
import '../connectors/table_list_connector.dart';
import '../models/exercise.dart';

class HomePage extends StatefulWidget {
  final Exercise? activeExercise;
  final List<String> exerciseNames;
  final Function(String exerciseName) removeExerciseName;

  const HomePage({
    super.key,
    this.activeExercise,
    required this.exerciseNames,
    required this.removeExerciseName,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: RotaryScrollbar(
        controller: _scrollController,
        child: PageView.builder(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          itemCount: widget.exerciseNames.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ButtonWithTitleBelow(
                icon: Icons.add,
                text: "Add",
                onClick: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddExerciseConnector()),
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
            final exercise = widget.exerciseNames[index - 2];
            return GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Material(
                      type: MaterialType.transparency,
                      child: MyDialog(
                        title: "Delete exercise?",
                        leftText: "Cancel",
                        rightText: "Delete",
                        onLeftButton: () => Navigator.of(context).pop(),
                        onRightButton: () {
                          widget.removeExerciseName(exercise);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              },
              child: ButtonWithTitleBelow(
                svgAsset: "assets/svg/${exercise.trim().toLowerCase().replaceAll(" ", '')}.svg",
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
                              list: TableListConnector(
                                displayEndExercise: true,
                              ),
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
              ),
            );
          },
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
            Padding(padding: const EdgeInsets.all(12.0), child: widget.list),
            Container(height: 30),
          ],
        ),
      ),
    );
  }
}
