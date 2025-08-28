import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:my_workout/models/exercise.dart';

import '../models/one_set.dart';

class StopwatchWidget extends StatefulWidget {
  final Duration elapsedTime;
  final bool isRunning;
  final Function startStopwatch;
  final Function pauseStopwatch;
  final Function resetStopwatch;
  final Exercise? exercise;
  final int time;
  final Function(OneSet oneSet, String name) addOneSet;

  const StopwatchWidget({
    super.key,
    required this.elapsedTime,
    required this.isRunning,
    required this.startStopwatch,
    required this.pauseStopwatch,
    required this.resetStopwatch,
    required this.exercise,
    required this.time,
    required this.addOneSet,
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
    _elapsedTimeString = _formatRemainingTime(
      Duration(seconds: widget.elapsedTime.inSeconds),
    );
    _updateElapsedTime();
  }

  @override
  void didUpdateWidget(covariant StopwatchWidget oldWidget) {
    _updateElapsedTime();
    super.didUpdateWidget(oldWidget);
  }

  void _updateElapsedTime() {
    duration = Duration(seconds: widget.time);
    setState(() {
      _elapsedTimeString = _formatRemainingTime(duration);
    });
  }

  String _formatRemainingTime(Duration time) {
    final hours = time.inHours.toString().padLeft(2, '0');
    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (false)
          Positioned.fill(
            child: CustomPaint(
              size: const Size(200, 200),
              painter: DottedRingPainter(
                dotsCount: widget.exercise?.completedSets.length ?? 0,
                radius: 90,
                dotColor: Colors.grey,
              ),
            ),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            Text(
              widget.exercise?.name ?? "-",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            GestureDetector(
              onDoubleTap: () {
                widget.addOneSet(
                  OneSet(_formatRemainingTime(duration), 5.toString()),
                  widget.exercise!.name!,
                );
              },
              child: Text(
                _elapsedTimeString,
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
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
                        iconColor: Colors.grey[900],
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
                          widget.isRunning
                              ? Icon(Icons.stop)
                              : Icon(Icons.not_started_sharp),
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
      ],
    );
  }
}

class DottedRingPainter extends CustomPainter {
  final int dotsCount;
  final double radius;
  final Color dotColor;

  DottedRingPainter({
    required this.dotsCount,
    required this.radius,
    this.dotColor = const Color(0xFF000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = dotColor;

    for (int i = 0; i < dotsCount; i++) {
      double angle = i * (180 / dotsCount) * (Math.pi / 180);

      final dx = center.dx + radius * Math.cos(angle - Math.pi);
      final dy = center.dy + radius * Math.sin(angle - Math.pi);

      canvas.drawCircle(Offset(dx, dy), 3, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
