class Reserve {
  int id;
  String establishment;
  double appPayment;
  double cashPayment;
  String deliveryAddress;
  String date;
 
  ReserveStatus status;

  Reserve(
      {required this.appPayment,
      required this.cashPayment,
      required this.deliveryAddress,
      required this.establishment,
      required this.id,
      required this.date,
     
      this.status = ReserveStatus.pending});

  static Reserve fromJson(Map<String, dynamic> json) {
    return Reserve(
        appPayment: double.parse(json['total'].toString()),
        cashPayment: 0,
        deliveryAddress: '',
        establishment: json['establishment'],
        status: getStatus(json['status']),
        id: json['id'],
        date: json['date'],);
  }

  static ReserveStatus getStatus(String status) {
    switch (status) {
      case 'Aceptada':
        return ReserveStatus.accepted;
      case 'Pendiente':
        return ReserveStatus.pending;
      case 'Rechazada':
        return ReserveStatus.rejected;
      default:
        return ReserveStatus.deliver;
    }
  }
}

enum ReserveStatus { pending, accepted, deliver, rejected }
