import 'one_set.dart';

class Exercise {
  final String? name;
  final int? setsNumber;
  final int? repsNumber;
  final int? restTime;
  final int? stopwatchFullTime;
  final DateTime? stopwatchStartTime;
  final List<OneSet> completedSets;

  Exercise({
    this.name,
    this.setsNumber,
    this.repsNumber,
    this.restTime,
    this.stopwatchFullTime,
    this.stopwatchStartTime,
    List<OneSet>? completedSets,
  }) : completedSets = completedSets ?? [];

  factory Exercise.initial() {
    return Exercise(
      name: null,
      setsNumber: null,
      repsNumber: null,
      restTime: null,
      stopwatchFullTime: null,
      completedSets: [],
      stopwatchStartTime: null,
    );
  }

  Exercise copyWith({
    String? name,
    int? setsNumber,
    int? repsNumber,
    int? restTime,
    int? stopwatchFullTime,
    List<OneSet>? completedSets,
    DateTime? stopwatchStartTime,
  }) {
    return Exercise(
      name: name ?? this.name,
      setsNumber: setsNumber ?? this.setsNumber,
      repsNumber: repsNumber ?? this.repsNumber,
      restTime: restTime ?? this.restTime,
      stopwatchFullTime: stopwatchFullTime ?? this.stopwatchFullTime,
      completedSets: completedSets ?? List.from(this.completedSets),
      stopwatchStartTime: stopwatchStartTime ?? this.stopwatchStartTime,
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    setsNumber: json['setsNumber'],
    restTime: json['restTime'],
    stopwatchFullTime: json['stopwatchFullTime'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'setsNumber': setsNumber,
    'restTime': restTime,
    'stopwatchFullTime': stopwatchFullTime,
  };

  @override
  String toString() {
    return 'Exercise{name: $name, setsNumber: $setsNumber, repsNumber: $repsNumber, restTime: $restTime, stopwatchFullTime: $stopwatchFullTime, completedSets: $completedSets, stopwatchStartTime: $stopwatchStartTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          setsNumber == other.setsNumber &&
          repsNumber == other.repsNumber &&
          restTime == other.restTime &&
          stopwatchFullTime == other.stopwatchFullTime &&
          completedSets == other.completedSets &&
          stopwatchStartTime == other.stopwatchStartTime;

  @override
  int get hashCode => Object.hash(
    name,
    setsNumber,
    repsNumber,
    restTime,
    stopwatchFullTime,
    completedSets,
    stopwatchStartTime,
  );
}
