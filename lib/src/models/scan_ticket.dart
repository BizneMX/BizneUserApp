class ScanTicket {
  final double total;
  final double totalWithDiscount;
  final double cashback;
  final double payWithPoints;
  final bool bizneApp;
  final String ticket;
  final int establishment;
  final String matrix;
  final double diners;

  const ScanTicket(
      {required this.total,
      required this.totalWithDiscount,
      required this.cashback,
      required this.payWithPoints,
      required this.bizneApp,
      required this.ticket,
      required this.establishment,
      required this.matrix,
      required this.diners});

  static ScanTicket fromJson(Map<String, dynamic> json) {
    return ScanTicket(
        total: double.parse(json['total'].toString()),
        totalWithDiscount: double.parse(json['total_with_discount'].toString()),
        cashback: double.parse(json['cashback'].toString()),
        payWithPoints: double.parse(json['pay_with_points'].toString()),
        bizneApp: json['bizne_app'],
        ticket: json['ticket'],
        establishment: json['establishment'],
        matrix: json['matrix'].toString(),
        diners: double.parse(json['diners'].toString()));
  }
}
