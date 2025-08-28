import 'package:flutter/material.dart';

import 'number_picker_page.dart';

class StartExercisePage extends StatefulWidget {
  final String exerciseName;
  final Function(int? reps, int? sets, String exerciseName) onStart;

  const StartExercisePage({
    super.key,
    required this.onStart,
    required this.exerciseName,
  });

  @override
  State<StartExercisePage> createState() => _StartExercisePageState();
}

class _StartExercisePageState extends State<StartExercisePage> {
  int? sets;
  int? reps;

  Future<void> _chooseNumber(String label, int? currentValue) async {
    final newValue = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder:
            (_) => NumberPickerPage(label: label, initialValue: currentValue),
      ),
    );
    setState(() {
      if (label == "Sets") {
        sets = newValue;
      } else {
        reps = newValue;
      }
    });
  }

  void _startExercise() {
    widget.onStart(reps, sets, widget.exerciseName);
  }

  Widget _circleButton(String label, int? value) {
    return InkWell(
      onTap: () => _chooseNumber(label, value),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green[700],
        ),
        child: Center(
          child: Text(
            value != null ? "$label\n$value" : label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Start ${widget.exerciseName}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circleButton("Sets", sets),
            const SizedBox(width: 20),
            _circleButton("Reps", reps),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _startExercise,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Start",
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
