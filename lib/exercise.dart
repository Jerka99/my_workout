import 'models/one_set.dart';

class Exercise {
  final String? name;
  final int? seriesNumber;
  final int? restTime;
  final int? stopwatchFullTime;
  final DateTime? stopwatchStartTime;
  final List<OneSet> completedSets;

  Exercise({
    this.name,
    this.seriesNumber,
    this.restTime,
    this.stopwatchFullTime,
    this.stopwatchStartTime,
    List<OneSet>? completedSets,
  }) : completedSets = completedSets ?? [];

  /// Factory for initial empty exercise
  factory Exercise.initial() {
    return Exercise(
      name: null,
      seriesNumber: null,
      restTime: null,
      stopwatchFullTime: null,
      completedSets: [],
      stopwatchStartTime: null,
    );
  }

  /// Create a copy with new values
  Exercise copyWith({
    String? name,
    int? seriesNumber,
    int? restTime,
    int? stopwatchFullTime,
    List<OneSet>? completedSets,
    DateTime? stopwatchStartTime,
  }) {
    return Exercise(
      name: name ?? this.name,
      seriesNumber: seriesNumber ?? this.seriesNumber,
      restTime: restTime ?? this.restTime,
      stopwatchFullTime: stopwatchFullTime ?? this.stopwatchFullTime,
      completedSets: completedSets ?? List.from(this.completedSets),
      stopwatchStartTime: stopwatchStartTime ?? this.stopwatchStartTime,
    );
  }

  /// JSON serialization
  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    seriesNumber: json['seriesNumber'],
    restTime: json['restTime'],
    stopwatchFullTime: json['stopwatchFullTime'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'seriesNumber': seriesNumber,
    'restTime': restTime,
    'stopwatchFullTime': stopwatchFullTime,
  };

  @override
  String toString() {
    return 'Exercise{name: $name, seriesNumber: $seriesNumber, restTime: $restTime, stopwatchFullTime: $stopwatchFullTime, completedSets: $completedSets, stopwatchStartTime: $stopwatchStartTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          seriesNumber == other.seriesNumber &&
          restTime == other.restTime &&
          stopwatchFullTime == other.stopwatchFullTime &&
          completedSets == other.completedSets &&
          stopwatchStartTime == other.stopwatchStartTime;

  @override
  int get hashCode => Object.hash(
    name,
    seriesNumber,
    restTime,
    stopwatchFullTime,
    completedSets,
    stopwatchStartTime,
  );
}
