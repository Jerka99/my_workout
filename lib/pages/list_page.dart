import 'package:flutter/material.dart';
import 'package:wear_os_plugin/wear_os_scroll_view.dart';
import '../models/exercise.dart';
import '../models/exercise_session.dart';
import 'table_list_page.dart';

class ListPage extends StatefulWidget {
  final List<ExerciseSession> sessionList;
  final Function(ExerciseSession selectedSession) onLongPressEnd;

  const ListPage({
    super.key,
    required this.sessionList,
    required this.onLongPressEnd,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<ExerciseSession>> grouped = {};
    for (var session in widget.sessionList) {
      final key =
          "${session.dateTime.year}-${session.dateTime.month}-${session.dateTime.day}";
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(session);
    }

    return WearOsScrollView(
      controller: scrollController,
      child: ListView(
        controller: scrollController,
        children:
            grouped.entries.map((entry) {
              final dateParts = entry.key.split("-");
              final dayStr =
                  "${dateParts[2].padLeft(2, '0')}.${dateParts[1].padLeft(2, '0')}.${dateParts[0]}.";

              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 22),
                child: ExpansionTile(
                  title: Text(
                    dayStr,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children:
                      entry.value.map((ExerciseSession session) {
                        return RemovableTable(
                          session: session,
                          onLongPressEnd:
                              (ExerciseSession selectedSession) =>
                                  widget.onLongPressEnd(selectedSession),
                        );
                      }).toList(),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class RemovableTable extends StatefulWidget {
  final ExerciseSession session;
  final Function(ExerciseSession selectedSession) onLongPressEnd;

  const RemovableTable({
    super.key,
    required this.session,
    required this.onLongPressEnd,
  });

  @override
  State<RemovableTable> createState() => _RemovableTableState();
}

class _RemovableTableState extends State<RemovableTable> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() => isPressed = true);
      },
      onLongPressMoveUpdate:
          (_) => {
            setState(() {
              isPressed = false;
            }),
          },
      onLongPressCancel:
          () => {
            setState(() {
              isPressed = false;
            }),
          },
      onLongPressEnd:
          (_) => {
            setState(() {
              isPressed = false;
            }),
            widget.onLongPressEnd(widget.session),
          },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: Card(
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.session.exerciseName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  color: isPressed ? Colors.red : Colors.transparent,

                  child: TableListPage(
                    exercise: Exercise(
                      completedSets: widget.session.completedSets,
                    ),
                    key: ValueKey(widget.session.exerciseName),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
