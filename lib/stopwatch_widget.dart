import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_workout/exercise.dart';

class StopwatchWidget extends StatefulWidget {
  final Duration elapsedTime;
  final bool isRunning;
  final Function startStopwatch;
  final Function pauseStopwatch;
  final Function resetStopwatch;
  final Exercise? exercise;
  final int time;

  const StopwatchWidget({
    super.key,
    required this.elapsedTime,
    required this.isRunning,
    required this.startStopwatch,
    required this.pauseStopwatch,
    required this.resetStopwatch,
    required this.exercise,
    required this.time,
  });

  @override
  State<StopwatchWidget> createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  late String _elapsedTimeString;
  late int finishTime;
  late Duration duration = const Duration(milliseconds: 0);

  @override
  void initState() {
    super.initState();
    finishTime = 5;
    _elapsedTimeString = _formatRemainingTime(
      Duration(seconds: min(widget.elapsedTime.inSeconds, finishTime * 60)),
    );
    _updateElapsedTime();
  }

  @override
  void didUpdateWidget(covariant StopwatchWidget oldWidget) {
    _updateElapsedTime();
    super.didUpdateWidget(oldWidget);
  }

  void _updateElapsedTime() {
    duration = Duration(
      seconds: min(
        widget.time,
        Duration(seconds: finishTime * 60).inMilliseconds,
      ),
    );
    setState(() {
      _elapsedTimeString = _formatRemainingTime(duration);
    });
    if (isStopwatchDisabled()) {
      // widget.pauseStopwatch();
    }
  }

  bool isStopwatchDisabled() {
    return duration.inSeconds >= Duration(minutes: finishTime).inSeconds;
  }

  String _formatRemainingTime(Duration time) {
    final hours = time.inHours.toString().padLeft(2, '0');
    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.exercise?.name ?? "-",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              _elapsedTimeString,
              style: TextStyle(color: Colors.white, fontSize: 45),
            ),
            SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                        iconColor: Colors.black,
                      ),
                      onPressed: () {
                        if (widget.isRunning == false) {
                          widget.startStopwatch();
                        }

                        if (widget.isRunning == true) {
                          widget.pauseStopwatch();
                        }
                      },
                      child:
                          widget.isRunning && !isStopwatchDisabled()
                              ? Icon(Icons.cancel)
                              : Icon(Icons.start),
                    ),
                  ),
                  SizedBox(width: 33),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        iconColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(210, 64, 64, 1),
                      ),
                      onPressed: () {
                        widget.resetStopwatch();
                      },
                      child: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
