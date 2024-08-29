class PaymentMethod {
  int id;
  int? cardId;
  String type;
  String? last4;
  String? brand;
  String? user;
  bool active;

  PaymentMethod(
      {required this.id,
      required this.cardId,
      required this.type,
      required this.last4,
      required this.brand,
      required this.user,
      required this.active});

  static PaymentMethod fromJson(Map<String, dynamic> json) => PaymentMethod(
      id: json['id'],
      cardId: json['cardId'],
      type: json['type'],
      last4: json['last4'],
      brand: json['brand'],
      user: json['user'],
      active: json['active'] == 1);
}
