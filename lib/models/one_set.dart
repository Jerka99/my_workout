class OneSet {
  String moment;
  String repeats;

  OneSet(this.moment, this.repeats);

  Map<String, dynamic> toJson() => {
    'moment': moment,
    'repeats': repeats,
  };

  OneSet.fromJson(Map<String, dynamic> json)
      : moment = json['moment'],
        repeats = json['repeats'];

}
