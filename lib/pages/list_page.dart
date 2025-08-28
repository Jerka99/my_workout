import 'package:flutter/material.dart';
import 'package:rotary_scrollbar/widgets/rotary_scrollbar.dart';
import '../models/exercise.dart';
import '../models/exercise_session.dart';
import 'table_list_page.dart';

class ListPage extends StatelessWidget {
  final List<ExerciseSession> sessionList;

  const ListPage({super.key, required this.sessionList});

  @override
  Widget build(BuildContext context) {
    final scrollController = PageController();

    return RotaryScrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(8.0),
        itemCount: sessionList.length,
        itemBuilder: (context, index) {
          final session = sessionList[index];
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${session.dateTime.month.toString().padLeft(2, '0')}.${session.dateTime.day.toString().padLeft(2, '0')}.${session.dateTime.year}. - ${session.exerciseName}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TableListPage(
                    exercise: Exercise(completedSets: session.completedSets),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
