import 'dart:convert';

class Exercise {
  final String? name;
  final int? seriesNumber;
  final int? restTime;
  final int? stopwatchFullTime;
  final List<DateTime> completedSetsTimestamps;

  Exercise({
    this.name,
    this.seriesNumber,
    this.restTime,
    this.stopwatchFullTime,
    List<DateTime>? completedSetsTimestamps,
  }) : completedSetsTimestamps = completedSetsTimestamps ?? [];

  /// Factory for initial empty exercise
  factory Exercise.initial() {
    return Exercise(
      name: null,
      seriesNumber: null,
      restTime: null,
      stopwatchFullTime: null,
      completedSetsTimestamps: [],
    );
  }

  /// Create a copy with new values
  Exercise copyWith({
    String? name,
    int? seriesNumber,
    int? restTime,
    int? stopwatchFullTime,
    List<DateTime>? completedSetsTimestamps,
  }) {
    return Exercise(
      name: name ?? this.name,
      seriesNumber: seriesNumber ?? this.seriesNumber,
      restTime: restTime ?? this.restTime,
      stopwatchFullTime: stopwatchFullTime ?? this.stopwatchFullTime,
      completedSetsTimestamps:
          completedSetsTimestamps ?? List.from(this.completedSetsTimestamps),
    );
  }

  /// JSON serialization
  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    seriesNumber: json['seriesNumber'],
    restTime: json['restTime'],
    stopwatchFullTime: json['stopwatchFullTime'],
    completedSetsTimestamps:
        (json['completedSetsTimestamps'] as List<dynamic>?)
            ?.map((e) => DateTime.parse(e))
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'seriesNumber': seriesNumber,
    'restTime': restTime,
    'stopwatchFullTime': stopwatchFullTime,
    'completedSetsTimestamps':
        completedSetsTimestamps.map((e) => e.toIso8601String()).toList(),
  };

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exercise &&
        other.name == name &&
        other.seriesNumber == seriesNumber &&
        other.restTime == restTime &&
        other.stopwatchFullTime == stopwatchFullTime &&
        _listEquals(other.completedSetsTimestamps, completedSetsTimestamps);
  }

  @override
  int get hashCode =>
      name.hashCode ^
      seriesNumber.hashCode ^
      restTime.hashCode ^
      stopwatchFullTime.hashCode ^
      completedSetsTimestamps.hashCode;

  static bool _listEquals(List<DateTime> a, List<DateTime> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
