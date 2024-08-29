class Organization {
  final int id;
  final String name;
  final String? pic;
  final String? validateField;

  Organization(
      {required this.id, required this.name, this.pic, this.validateField});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        id: json['id'],
        name: json['name'],
        pic: json["pic"],
        validateField: json["validateField"]);
  }
}

class Sector {
  final int id;
  final String name;

  Sector({required this.id, required this.name});

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      id: json['id'],
      name: json['name'],
    );
  }
}
