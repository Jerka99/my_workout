import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/models/exercise.dart';

import '../models/one_set.dart';

class TableListPage extends StatelessWidget {
  final Exercise? exercise;
  final bool displayEndExercise;
  final Function(String name)? endActivity;

  const TableListPage({
    super.key,
    this.exercise,
    bool? displayEndExercise,
    this.endActivity,
  }) : displayEndExercise = displayEndExercise ?? false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(width: 2, color: Colors.green),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
          },
          children: [
            TableRow(children: createRow("Set", "Time", "Rep")),
            if (exercise?.completedSets != null)
              ...exercise!.completedSets.asMap().entries.map((entry) {
                final i = entry.key;
                OneSet set = entry.value;
                String moment = set.moment;
                if (set.moment.startsWith("00:")) {
                  moment = set.moment.substring(3);
                }
                return TableRow(
                  children: createRow("${i + 1}.", moment, set.repeats),
                );
              }),
          ],
        ),
        if (displayEndExercise) ...[
          Container(height: 12),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                minimumSize: const Size(80, 32),
              ),
              onPressed: () {
                if (endActivity != null) endActivity!(exercise!.name!);
              },
              child: const Text(
                "SAVE AND FINISH",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

List<Widget> createRow(String text1, String text2, String text3) {
  return [
    SizedBox(
      width: 22,
      height: 22,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4),
        child: Text(
          text1,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    ),
    SizedBox(
      width: 22,
      height: 22,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4),
        child: Text(
          text2,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    ),
    SizedBox(
      width: 22,
      height: 22,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, top: 4),
        child: Text(
          text3,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    ),
  ];
}
