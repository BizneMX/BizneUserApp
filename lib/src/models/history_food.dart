class HistoryFood {
  int id;
  String estabName;
  String date;
  String pic;

  HistoryFood(
      {required this.id,
      required this.estabName,
      required this.date,
      required this.pic});

  static HistoryFood fromJson(Map<String, dynamic> json) => HistoryFood(
      id: json['id'],
      estabName: json['estab_name'],
      date: json['date'],
      pic: json['pic']);
}

// class HistoryConsume {
//   String date;
//   String points;
//   String type;
//   String concept;
//   double cash;

//   HistoryConsume({required this.date, required this.points, required this.type, required this.concept, required this.cash})

//   static HistoryConsume fromJson(Map<String, dynamic> json) => HistoryConsume(
//       date: json['date'],
//       points: json['points'],
//       type: json['type'],
//       concept: json['pic']);
// }
// "date": "05/Apr/2024",
// "points": "56.00",
// "type": "OUT",
// "concept": "Consumo El Joy",
// "cash": 44
