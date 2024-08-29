class Consumption {
  final String date;
  final String points;
  final String type;
  final String concept;
  final String cash;

  Consumption(
      {required this.date,
      required this.points,
      required this.type,
      required this.concept,
      required this.cash});

  factory Consumption.fromJson(Map<String, dynamic> json) {
    return Consumption(
        date: json['date'],
        points: json['points'],
        type: json['type'],
        concept: json['concept'],
        cash: json['cash'] == null ? '0' : json['cash'].toString());
  }
}
