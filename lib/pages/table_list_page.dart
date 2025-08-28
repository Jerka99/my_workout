import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_workout/models/exercise.dart';

import '../models/one_set.dart';

class TableListPage extends StatelessWidget {
  final Exercise? exercise;

  const TableListPage({super.key, this.exercise});

  @override
  Widget build(BuildContext context) {
    return Table(
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
