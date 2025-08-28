import 'one_set.dart';

class ExerciseSession {
  String exerciseName;
  DateTime dateTime;
  List<OneSet> completedSets;

  ExerciseSession({
    required this.exerciseName,
    required this.dateTime,
    required this.completedSets,
  });

  Map<String, dynamic> toJson() => {
    'exerciseName': exerciseName,
    'dateTime': dateTime.toIso8601String(),
    'completedSets': completedSets.map((e) => e.toJson()).toList(),
  };

  factory ExerciseSession.fromJson(Map<String, dynamic> json) =>
      ExerciseSession(
        exerciseName: json['exerciseName'],
        dateTime: DateTime.parse(json['dateTime']),
        completedSets:
            (json['completedSets'] as List)
                .map((e) => OneSet.fromJson(Map<String, dynamic>.from(e)))
                .toList(),
      );
}
