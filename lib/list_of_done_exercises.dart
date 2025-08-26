import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListOfDoneExercises extends StatelessWidget {
  final String exerciseName;

  ListOfDoneExercises({required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exerciseName)),
      body: Center(child: Text('List will be filled from SQLite later')),
    );
  }
}
