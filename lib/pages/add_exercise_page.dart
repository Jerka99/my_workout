import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciseAddPage extends StatefulWidget {
  @override
  _ExerciseAddPageState createState() => _ExerciseAddPageState();
}

class _ExerciseAddPageState extends State<ExerciseAddPage> {
  final TextEditingController _controller = TextEditingController();

  void _addExercise() {
    String newExercise = _controller.text.trim();
    if (newExercise.isNotEmpty) {
      Navigator.pop(context, newExercise);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Exercise Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _addExercise, child: Text('Add')),
          ],
        ),
      );
  }
}
