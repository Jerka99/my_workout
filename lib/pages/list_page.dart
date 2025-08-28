import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../exercise.dart';
import '../models/exercise_session.dart';
import 'table_list.dart';

class ListPage extends StatelessWidget {
  final List<ExerciseSession> sessionList;

  const ListPage({super.key, required this.sessionList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: ListView.builder(
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
                        "${session.dateTime.toLocal()} - ${session.exerciseName}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TableList(
                        exercise: Exercise(
                          completedSets: session.completedSets,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
