import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_workout/pages/stopwatch_with_list.dart';
import 'package:wear_os_plugin/wear_os_plugin.dart';
import 'package:my_workout/connectors/add_exercise_connector.dart';
import 'package:my_workout/connectors/stopwatch_connector.dart';
import 'package:my_workout/main.dart';
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

class _HomePageState extends State<HomePage> with RouteAware {
  final PageController _pageController = PageController();
  late final StreamController<MotionData> _rotaryController;
  StreamSubscription<MotionData>? _rotarySub;
  double _accum = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _rotaryController = WearOsPlugin.instance.registerForMotionEvents;
    _rotarySub = _rotaryController.stream.listen((m) {
      final delta = m.scroll ?? 0;
      if (delta == 0) return;

      _accum += delta;

      if (_accum > 0.05) {
        _accum = 0;
        if (_currentPage > 0) {
          _currentPage--;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
          setState(() {});
        }
      } else if (_accum < -0.01) {
        _accum = 0;
        if (_currentPage < widget.exerciseNames.length + 1) {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
          );
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _rotarySub?.cancel();
    WearOsPlugin.instance.unregisterFromMotionEvents(_rotaryController);
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPageIndicator() {
    int totalPages = widget.exerciseNames.length + 2;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalPages, (index) {
            return Container(
              width: 4,
              height: index == _currentPage ? 14 : 8,
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: index == _currentPage ? Colors.orange : Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: widget.exerciseNames.length + 2,
            onPageChanged: (index) {
              _currentPage = index;
              setState(() {});
            },
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
                  svgAsset:
                      "assets/svg/${exercise.trim().toLowerCase().replaceAll(" ", '')}.svg",
                  enabledColor: const Color.fromARGB(178, 255, 166, 0),
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
          Positioned(right: 11,top: 0, bottom: 0, child: _buildPageIndicator()),
        ],
      ),
    );
  }
}
